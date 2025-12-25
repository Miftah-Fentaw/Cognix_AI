import 'dart:convert';
import 'package:cognix/model/chat_message.dart';
import 'package:cognix/model/AIResponse.dart';
import 'package:cognix/services/chat_history_service.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';

class ChatController {
  List<ChatMessage> messages = [];
  bool isLoading = false;

  // Backend endpoints to try (order: LAN IP, emulator, localhost via adb reverse)
  final List<String> backendCandidates = [
    'http://10.230.37.240:8000/api/process-text/', // Current LAN IP
    'http://10.0.2.2:8000/api/process-text/', // Android emulator host
    'http://127.0.0.1:8000/api/process-text/', // adb reverse maps device localhost to host
  ];

  final ChatHistoryService _historyService = ChatHistoryService();
  String? _currentChatId;

  // Constructor to start a fresh chat on init if needed
  ChatController() {
    startNewChat();
  }

  void startNewChat() {
    _currentChatId = const Uuid().v4();
    messages.clear();
  }

  Future<void> loadChat(ChatSession session) async {
    _currentChatId = session.id;
    messages = List.from(session.messages);
  }

  Future<void> _saveCurrentChat() async {
    if (messages.isEmpty || _currentChatId == null) return;

    // Use the first user message as the preview text
    String preview = "New Chat";
    final firstUserMsg = messages.where((m) => m.isUser).firstOrNull;
    if (firstUserMsg != null) {
      preview = firstUserMsg.text;
      if (preview.length > 50) preview = "${preview.substring(0, 50)}...";
    }

    final session = ChatSession(
      id: _currentChatId!,
      timestamp: DateTime.now(),
      preview: preview,
      messages: messages,
    );

    await _historyService.saveChat(session);
  }

  void sendMessage(String text, Function setState) async {
    if (text.trim().isEmpty) return;

    // Add user message first
    messages.add(ChatMessage(text: text, isUser: true));
    isLoading = true;
    setState(() {});

    try {
      // Try candidate endpoints sequentially until one succeeds
      http.Response? response;
      String? usedUrl;
      for (final url in backendCandidates) {
        try {
          print('Trying POST $url body=${jsonEncode({'text': text})}');
          response = await http.post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'text': text}),
          );
          print('Response from $url: ${response.statusCode}');
          if (response.statusCode == 200) {
            usedUrl = url;
            break;
          }
        } catch (e) {
          print('Failed to reach $url: $e');
          // try next
        }
      }

      if (response == null)
        throw Exception('No response from any backend candidates');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Parse the JSON response into AIResponse model
        final aiResponse = AIResponse.fromJson(data);

        // Create a simple preview text for the chat bubble
        final previewText =
            'Cognix AI Response Ready - Tap to view Summary, Notes, or Q&A';

        messages.add(ChatMessage(
          text: previewText,
          isUser: false,
          aiResponse: aiResponse, // Store structured data
        ));

        // Save chat after successful response
        await _saveCurrentChat();
      } else {
        messages.add(ChatMessage(
            text: 'Server Error: ${response.statusCode}', isUser: false));
      }
    } catch (e) {
      messages.add(ChatMessage(text: 'Connection Error: $e', isUser: false));
    }

    isLoading = false;
    setState(() {});
  }

  Future<void> pickAndUploadFile(Function setState) async {
    try {
      // 1. Pick File
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'pptx'],
      );

      if (result == null || result.files.single.path == null) return;

      final filePath = result.files.single.path!;
      final fileName = result.files.single.name;

      // Add a temporary message showing we are uploading
      messages.add(ChatMessage(
        text: 'Uploading $fileName...',
        isUser: true,
      ));
      isLoading = true;
      setState(() {});

      // 2. Upload to Backend
      // We'll reuse the backend selection logic or just try the first working one
      // For simplicity, we'll iterate candidates again or use a known good one if stored.
      // Since we don't persist 'usedUrl', we'll loop.

      http.StreamedResponse? streamedResponse;

      for (final baseUrl in backendCandidates) {
        try {
          // Construct correct file endpoint from the base text endpoint
          // e.g. http://.../api/process-text/ -> http://.../api/process-file/
          final fileUrl = baseUrl.replaceAll('process-text/', 'process-file/');

          print('Trying POST FILE $fileUrl');

          var request = http.MultipartRequest('POST', Uri.parse(fileUrl));
          request.files
              .add(await http.MultipartFile.fromPath('file', filePath));

          streamedResponse = await request.send();

          if (streamedResponse.statusCode == 200) {
            break;
          }
        } catch (e) {
          print('Upload failed to $baseUrl: $e');
        }
      }

      if (streamedResponse == null || streamedResponse.statusCode != 200) {
        throw Exception(
            'Upload failed. Server returned ${streamedResponse?.statusCode ?? "no response"}');
      }

      // 3. Process Response
      final responseBody = await streamedResponse.stream.bytesToString();
      final data = jsonDecode(responseBody);
      final aiResponse = AIResponse.fromJson(data);

      messages.add(ChatMessage(
        text: 'File Analyzed: $fileName',
        isUser: false,
        aiResponse: aiResponse,
      ));

      await _saveCurrentChat();
    } catch (e) {
      messages.add(ChatMessage(
        text: 'Error processing file: $e',
        isUser: false,
      ));
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  void clearChat(Function setState) {
    startNewChat();
    setState(() {});
  }
}

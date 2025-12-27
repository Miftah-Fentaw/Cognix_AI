// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:cognix/models/chat_message.dart';
import 'package:cognix/models/AIResponse.dart';
import 'package:cognix/services/chat_history_service.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';

class ChatController {
  List<ChatMessage> messages = [];
  bool isLoading = false;
  final String textEndpoint = 'http://10.230.37.240:8000/api/process-text/';
  final String fileEndpoint = 'http://10.230.37.240:8000/api/process-file/';

  // final List<String> backendCandidates = [
  //   'http://10.230.37.240:8000/api/process-text/', // Current LAN IP
  //   'http://10.0.2.2:8000/api/process-text/', // Android emulator host
  //   'http://127.0.0.1:8000/api/process-text/', // adb reverse maps device localhost to host
  // ];

  final ChatHistoryService _historyService = ChatHistoryService();
  String? _currentChatId;

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

  // Send text message to backend and handle response
  void sendMessage(String text, Function setState) async {
    if (text.trim().isEmpty) return;

    // Add user message first
    messages.add(ChatMessage(text: text, isUser: true));
    isLoading = true;
    setState(() {});

    try {
      print('POST $textEndpoint body=${jsonEncode({'text': text})}');
      final response = await http.post(
        Uri.parse(textEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        // Success
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

        // Save chat after successful response for offline access
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

  // Handle file picking, uploading, and response processing

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

      print('POST FILE $fileEndpoint');

      var request = http.MultipartRequest('POST', Uri.parse(fileEndpoint));
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      final streamedResponse = await request.send();

      // if upload failed
      if (streamedResponse.statusCode != 200) {
        throw Exception(
            'Upload failed. Server returned ${streamedResponse.statusCode}');
      }

      // if upload succeeded
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

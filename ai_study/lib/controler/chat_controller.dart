import 'dart:convert';
import 'package:cognix/model/chat_message.dart';
import 'package:cognix/model/AIResponse.dart';
import 'package:http/http.dart' as http;

class ChatController {
  List<ChatMessage> messages = [];
  bool isLoading = false;

  // Backend endpoints to try (order: LAN IP, emulator, localhost via adb reverse)
  final List<String> backendCandidates = [
    'http://192.168.0.132:8000/api/process-text/', // replace with your PC LAN IP
    'http://10.0.2.2:8000/api/process-text/', // Android emulator host
    'http://127.0.0.1:8000/api/process-text/', // adb reverse maps device localhost to host
  ];

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
            'AI Response Ready - Tap to view Summary, Notes, or Q&A';

        messages.add(ChatMessage(
          text: previewText,
          isUser: false,
          aiResponse: aiResponse, // Store structured data
        ));
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

  void clearChat(Function setState) {
    messages.clear();
    setState(() {});
  }
}

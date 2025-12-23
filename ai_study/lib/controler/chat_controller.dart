import 'package:cognix/model/chat_message.dart';
import '../services/chat_service.dart';

class ChatController {
  final ChatService _service = ChatService();

  final List<ChatMessage> messages = [];
  bool isLoading = false;

  Future<void> sendMessage(
    String text,
    void Function(void Function()) setState,
  ) async {
    if (text.trim().isEmpty) return;

    setState(() {
      messages.add(ChatMessage(text: text, isUser: true));
      isLoading = true;
    });

    final response = await _service.processText(text);

    setState(() {
      messages.add(ChatMessage(text: response, isUser: false));
      isLoading = false;
    });
  }

  void clearChat(void Function(void Function()) setState) {
    setState(() => messages.clear());
  }
}

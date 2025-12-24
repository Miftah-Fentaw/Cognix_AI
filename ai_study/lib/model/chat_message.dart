import 'package:cognix/model/AIResponse.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final AIResponse? aiResponse; // Store structured backend response

  ChatMessage({
    required this.text,
    required this.isUser,
    this.aiResponse,
  });
}

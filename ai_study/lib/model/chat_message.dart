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

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'aiResponse': aiResponse?.toJson(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'],
        isUser: json['isUser'],
        aiResponse: json['aiResponse'] != null
            ? AIResponse.fromJson(json['aiResponse'])
            : null,
      );
}

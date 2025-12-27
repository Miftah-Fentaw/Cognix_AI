import 'package:cognix/models/AIResponse.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String? filePath; // Path to local file if this message represents a file
  final String? fileType; 
  final AIResponse? aiResponse;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.aiResponse,
    this.filePath,
    this.fileType,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'aiResponse': aiResponse?.toJson(),
        'filePath': filePath,
        'fileType': fileType,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'],
        isUser: json['isUser'],
        aiResponse: json['aiResponse'] != null
            ? AIResponse.fromJson(json['aiResponse'])
            : null,
        filePath: json['filePath'],
        fileType: json['fileType'],
      );
}

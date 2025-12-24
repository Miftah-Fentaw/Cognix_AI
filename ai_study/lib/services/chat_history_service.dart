import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cognix/model/chat_message.dart';
import 'package:cognix/model/AIResponse.dart';

class ChatSession {
  final String id;
  final DateTime timestamp;
  final String preview; // Short text to show in history list
  final List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.timestamp,
    required this.preview,
    required this.messages,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'preview': preview,
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      preview: json['preview'],
      messages: (json['messages'] as List)
          .map((m) => ChatMessage.fromJson(m))
          .toList(),
    );
  }
}

class ChatHistoryService {
  static const String _key = 'chat_sessions_v1';

  Future<void> saveChat(ChatSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> sessionsJson = prefs.getStringList(_key) ?? [];

    // Remove existing session with same ID if exists (update)
    final existingIndex = sessionsJson.indexWhere((s) {
      final map = jsonDecode(s);
      return map['id'] == session.id;
    });

    if (existingIndex != -1) {
      sessionsJson[existingIndex] = jsonEncode(session.toJson());
    } else {
      // Add new session to top of list
      sessionsJson.insert(0, jsonEncode(session.toJson()));
    }

    await prefs.setStringList(_key, sessionsJson);
  }

  Future<List<ChatSession>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> sessionsJson = prefs.getStringList(_key) ?? [];

    return sessionsJson
        .map((s) => ChatSession.fromJson(jsonDecode(s)))
        .toList();
  }

  Future<void> deleteChat(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> sessionsJson = prefs.getStringList(_key) ?? [];

    sessionsJson.removeWhere((s) {
      final map = jsonDecode(s);
      return map['id'] == id;
    });

    await prefs.setStringList(_key, sessionsJson);
  }

  Future<void> clearAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

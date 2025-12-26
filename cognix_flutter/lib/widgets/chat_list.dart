import 'package:cognix/model/chat_message.dart';
import 'package:flutter/material.dart';
import 'chat_bubble.dart';
import 'empty_state.dart';

class ChatList extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isLoading;

  const ChatList({
    super.key,
    required this.messages,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) return const EmptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(),
          );
        }
        return ChatBubble(message: messages[index]);
      },
    );
  }
}

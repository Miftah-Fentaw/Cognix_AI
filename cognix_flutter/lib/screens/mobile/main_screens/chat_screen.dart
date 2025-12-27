// ignore_for_file: deprecated_member_use

import 'package:cognix/controllers/chat_controller.dart';
import 'package:cognix/services/chat_history_service.dart';
import 'package:cognix/widgets/chat_list.dart';
import 'package:cognix/widgets/input_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChattingScreen extends StatefulWidget {
  final ChatSession? session;
  const ChattingScreen({super.key, this.session});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final ChatController controller = ChatController();

  @override
  void initState() {
    super.initState();
    if (widget.session != null) {
      controller.loadChat(widget.session!);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // ← makes appbar transparent

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove default back button
        title: Row(
          children: [
            // New Chat button in top left
            IconButton(
              onPressed: () {
                controller.startNewChat();
                setState(() {});
              },
              icon: const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 28,
              ),
              tooltip: 'New Chat',
            ),
            const SizedBox(width: 8),
            Text(
              'Cognix',
              style: GoogleFonts.aDLaMDisplay(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // optional background overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.25),
            ),
          ),

          // Chat content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ChatList(
                    messages: controller.messages,
                    isLoading: controller.isLoading,
                  ),
                ),
                InputBar(
                  onSend: (text) => controller.sendMessage(text, setState),
                  onAttachment: () => controller.pickAndUploadFile(setState),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:cognix/controllers/chat_controller.dart';
import 'package:cognix/services/chat_history_service.dart';
import 'package:cognix/widgets/chat_list.dart';
import 'package:cognix/widgets/input_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      floatingActionButton: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          vertical: 70,
          horizontal: 0,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            controller.startNewChat();
            setState(() {});
          },
          child: Icon(Icons.note_add_rounded,color: Colors.blue.shade600,),
        ),
      ),
      extendBodyBehindAppBar: true, // ← makes appbar transparent
      backgroundColor: Color(0xFFF5F5F7),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () => context.pushReplacement('/'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove default back button
        title: Row(
          children: [
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

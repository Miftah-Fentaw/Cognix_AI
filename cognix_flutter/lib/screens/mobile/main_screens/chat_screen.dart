// ignore_for_file: deprecated_member_use

import 'package:cognix/controler/chat_controller.dart';
import 'package:cognix/screens/mobile/features/chat_history_screen.dart';
import 'package:cognix/screens/mobile/features/settings_screen.dart';
import 'package:cognix/widgets/chat_drawer.dart';
import 'package:cognix/widgets/chat_list.dart';
import 'package:cognix/widgets/input_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class chatting_screen extends StatefulWidget {
  const chatting_screen({super.key});

  @override
  State<chatting_screen> createState() => _chatting_screenState();
}

class _chatting_screenState extends State<chatting_screen> {
  final ChatController controller = ChatController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // ← makes appbar transparent 
      drawer: ChatDrawer(
        onNewChat: () {
          controller.clearChat(setState);
        },
        onShowHistory: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatHistoryScreen(
                onChatSelected: (session) async {
                  await controller.loadChat(session);
                  setState(() {}); 
                },
              ),
            ),
          );
        },
        onShowSettings: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          );
        },
      ),


      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Cognix',
          style: GoogleFonts.aDLaMDisplay(),
        ),

        // Drawer icon
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        // premium icon at the right aligned 
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                // use go route 
                GoRouter.of(context).go('/premium-feature');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.workspace_premium_outlined,color: Colors.orangeAccent,),
            ),
          )
          ),
        ],


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

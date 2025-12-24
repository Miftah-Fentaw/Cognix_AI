import 'package:cognix/controler/chat_controller.dart';
import 'package:cognix/screens/mobile/features/chat_history_screen.dart';
import 'package:cognix/screens/mobile/features/settings_screen.dart';
import 'package:cognix/widgets/chat_drawer.dart';
import 'package:cognix/widgets/chat_list.dart';
import 'package:cognix/widgets/input_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileHome extends StatefulWidget {
  const MobileHome({super.key});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  final ChatController controller = ChatController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // ← makes background visible behind appbar
      drawer: ChatDrawer(
        onNewChat: () {
          // Navigator.pop(context) is already called in the drawer
          controller.clearChat(setState);
        },
        onShowHistory: () {
          // Navigator.pop(context) is already called in the drawer
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatHistoryScreen(
                onChatSelected: (session) async {
                  await controller.loadChat(session);
                  setState(() {}); // Refresh UI with loaded messages
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
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/bkg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Optional: subtle overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.25), // adjust opacity
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

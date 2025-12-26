// ignore_for_file: deprecated_member_use
import 'package:cognix/widgets/drawer_item.dart';
import 'package:flutter/material.dart';

class ChatDrawer extends StatelessWidget {
  final VoidCallback onNewChat;
  final VoidCallback onShowHistory;
  final VoidCallback onShowSettings;

  const ChatDrawer({
    super.key,
    required this.onNewChat,
    required this.onShowHistory,
    required this.onShowSettings,
  });

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: Colors.transparent, 
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:[
                    Colors.blue.shade400,
                    Colors.blueGrey.shade500,
                    Colors.white,
                  ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withOpacity(0.3), width: 2),
                      ),
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("assets/cognix.png"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Cognix',
                      style: TextStyle(
                        fontFamily: 'ADLaMDisplay', 
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            DrawerItem(
              icon: Icons.chat_bubble_outline,
              label: 'New Chat',
              onTap: () {
                onNewChat();
                Navigator.pop(context);
              },
            ),
            DrawerItem(
              icon: Icons.history,
              label: 'Chat History',
              onTap: () {
                Navigator.pop(context); 
                onShowHistory(); 
              },
            ),
            DrawerItem(
              icon: Icons.settings,
              label: 'Settings',
              onTap: () {
                Navigator.pop(context);
                onShowSettings();
              },
            ),

            const Spacer(),
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    '© 2025 Cognix AI',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black
                          .withOpacity(0.7), 
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

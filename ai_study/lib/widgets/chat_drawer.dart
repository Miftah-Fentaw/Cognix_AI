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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: Colors.transparent, // ← Required for gradient to show
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Colors.blueGrey.shade900,
                    Colors.indigo.shade900,
                    Colors.deepPurple.shade900,
                  ]
                : [
                    Colors.blue.shade400,
                    Colors.indigo.shade500,
                    Colors.purple.shade600,
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
                        fontFamily: 'ADLaMDisplay', // Using the custom font
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
            // Your original content (unchanged)
            _DrawerItem(
              icon: Icons.chat_bubble_outline,
              label: 'New Chat',
              onTap: () {
                onNewChat();
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              icon: Icons.history,
              label: 'Chat History',
              onTap: () {
                Navigator.pop(context); // Close drawer
                onShowHistory(); // Trigger show history callback
              },
            ),
            _DrawerItem(
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
                    '© 2025 Cognix',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
                          .withOpacity(0.7), // better visibility on gradient
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.5),
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

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15), // subtle contrast on gradient
          borderRadius: BorderRadius.circular(12),
        ),
        child:
            Icon(icon, color: Colors.white, size: 22), // white for visibility
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white, // better contrast on gradient
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.white.withOpacity(0.6),
        size: 20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.transparent),
      ),
      onTap: onTap,
      hoverColor: Colors.white.withOpacity(0.15),
    );
  }
}

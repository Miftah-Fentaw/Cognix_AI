import 'package:flutter/material.dart';

class ChatDrawer extends StatelessWidget {
  final VoidCallback onNewChat;

  const ChatDrawer({super.key, required this.onNewChat});

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
              onTap: () {},
            ),
            _DrawerItem(
              icon: Icons.bookmark_outline,
              label: 'Saved Notes',
              onTap: () {},
            ),
            _DrawerItem(
              icon: Icons.settings,
              label: 'Settings',
              onTap: () {},
            ),
            _DrawerItem(
              icon: Icons.help_outline,
              label: 'Help & Support',
              onTap: () {},
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
                      color: Colors.white.withOpacity(0.7), // better visibility on gradient
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
        child: Icon(icon, color: Colors.white, size: 22), // white for visibility
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
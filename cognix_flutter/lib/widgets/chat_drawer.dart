// ignore_for_file: deprecated_member_use
import 'package:cognix/widgets/drawer_item.dart';
import 'package:flutter/material.dart';

class ChatDrawer extends StatelessWidget {
  final VoidCallback onShowHistory;
  final VoidCallback onResumeHistory;
  final VoidCallback onShowTranslationHistory;
  final VoidCallback onShowConversionHistory;
  final VoidCallback onShowFileGenHistory;
  final VoidCallback onShowSettings;

  const ChatDrawer({
    super.key,
    required this.onShowHistory,
    required this.onResumeHistory,
    required this.onShowTranslationHistory,
    required this.onShowConversionHistory,
    required this.onShowFileGenHistory,
    required this.onShowSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white.withOpacity(0.9),
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
                          color: Colors.orange.withOpacity(0.3), width: 2),
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
                      color: Colors.black87,
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
            icon: Icons.history,
            label: 'Chat History',
            onTap: () {
              Navigator.pop(context);
              onShowHistory();
            },
          ),
          DrawerItem(
            icon: Icons.description_outlined,
            label: 'Resume History',
            onTap: () {
              Navigator.pop(context);
              onResumeHistory();
            },
          ),
          DrawerItem(
            icon: Icons.translate,
            label: 'Translation History',
            onTap: () {
              Navigator.pop(context);
              onShowTranslationHistory();
            },
          ),
          DrawerItem(
            icon: Icons.transform, // Or another appropriate icon
            label: 'Conversion History',
            onTap: () {
              Navigator.pop(context);
              onShowConversionHistory();
            },
          ),
          DrawerItem(
            icon: Icons.auto_awesome_motion, // Or text_snippet
            label: 'Generation History',
            onTap: () {
              Navigator.pop(context);
              onShowFileGenHistory();
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
                    color: Colors.black.withOpacity(0.7),
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
    );
  }
}

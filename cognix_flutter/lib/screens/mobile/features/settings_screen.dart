// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cognix/services/chat_history_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Settings',
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSectionHeader(context, "Data & Privacy"),
                  _buildSettingTile(
                    context,
                    icon: Icons.delete_outline,
                    title: 'Clear All History',
                    textColor: Colors.redAccent,
                    iconColor: Colors.redAccent,
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.blueGrey.shade900,
                          title: const Text('Clear All History?',
                              style: TextStyle(color: Colors.white)),
                          content: const Text('This action cannot be undone.',
                              style: TextStyle(color: Colors.white70)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Clear All',
                                  style: TextStyle(color: Colors.redAccent)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await ChatHistoryService().clearAllHistory();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('History cleared')),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader(context, "About"),
                  _buildSettingTile(
                    context,
                    icon: Icons.info_outline,
                    title: 'Version',
                    trailing: const Text('1.0.0',
                        style: TextStyle(color: Colors.white54)),
                  ),
                  const SizedBox(height: 8),
                  _buildSettingTile(
                    context,
                    icon: Icons.code,
                    title: 'AI Model',
                    trailing: const Text('Llama 3.3 70B',
                        style: TextStyle(color: Colors.white54)),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: iconColor ?? Colors.white70),
        title: Text(title,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            )),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}

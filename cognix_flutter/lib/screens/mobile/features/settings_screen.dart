// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../utils/constants.dart';
import '../../../services/resume_service.dart';
import 'package:cognix/services/chat_history_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isTestingConnection = false;

  Future<void> _testServerConnection() async {
    setState(() {
      _isTestingConnection = true;
    });

    try {
      final result = await ResumeService.testConnection();
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.blueGrey.shade900,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(
                  result['success'] ? Icons.check_circle : Icons.error,
                  color: result['success'] ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  result['success'] ? 'Connection Success' : 'Connection Failed',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result['message'],
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Server: ${result['serverUrl'] ?? AppConstants.baseUrl}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection test failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTestingConnection = false;
        });
      }
    }
  }

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
                  _buildSectionHeader(context, "Server Connection"),
                  _buildSettingTile(
                    context,
                    icon: Icons.wifi,
                    title: 'Test Server Connection',
                    trailing: _isTestingConnection 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                            ),
                          )
                        : const Icon(Icons.play_arrow, color: Colors.white54),
                    onTap: _isTestingConnection ? null : _testServerConnection,
                  ),
                  const SizedBox(height: 8),
                  _buildSettingTile(
                    context,
                    icon: Icons.dns,
                    title: 'Server Address',
                    trailing: Text(
                      AppConstants.baseUrl,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                    trailing: Text(AppConstants.appVersion,
                        style: const TextStyle(color: Colors.white54)),
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

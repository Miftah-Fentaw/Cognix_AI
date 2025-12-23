import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotesScreen extends StatelessWidget {
  final String content;

  const NotesScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bullets = content
        .trim()
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Short Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: content.trim()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notes copied!')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: bullets.map((line) {
          final text = line.trim().replaceAll(RegExp(r'^[•\-\*]'), '').trim();
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: Colors.blue, fontSize: 20)),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
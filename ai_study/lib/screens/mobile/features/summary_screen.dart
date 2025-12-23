import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SummaryScreen extends StatelessWidget {
  final String content;

  const SummaryScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📘 Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: content.trim()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Summary copied!')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          content.trim(),
          style: TextStyle(
            fontSize: 17,
            height: 1.6,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
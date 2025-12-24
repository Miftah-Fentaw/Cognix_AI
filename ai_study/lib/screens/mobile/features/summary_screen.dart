import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SummaryScreen extends StatelessWidget {
  final String summary;

  const SummaryScreen({super.key, required this.summary});

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
              Clipboard.setData(ClipboardData(text: summary));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Summary copied!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(
          summary,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QAScreen extends StatelessWidget {
  final String content;

  const QAScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final qaPairs = _parseQaPairs(content);

    return Scaffold(
      appBar: AppBar(
        title: const Text('❓ Q&A Practice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: content.trim()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Full Q&A copied!')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: qaPairs.length,
        itemBuilder: (context, index) {
          final pair = qaPairs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: isDark ? Colors.grey.shade800 : Colors.white,
            child: ExpansionTile(
              title: Text(
                pair['question']!,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    pair['answer']!,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: isDark ? Colors.white70 : Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _parseQaPairs(String content) {
    final pairs = <Map<String, String>>[];
    final lines = content.trim().split('\n');

    String currentQ = '';
    String currentA = '';

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('Q:')) {
        if (currentQ.isNotEmpty) {
          pairs.add({'question': currentQ, 'answer': currentA.trim()});
        }
        currentQ = trimmed.substring(2).trim();
        currentA = '';
      } else if (trimmed.startsWith('A:')) {
        currentA += trimmed.substring(2).trim() + '\n';
      } else {
        currentA += trimmed + '\n';
      }
    }

    if (currentQ.isNotEmpty) {
      pairs.add({'question': currentQ, 'answer': currentA.trim()});
    }

    return pairs;
  }
}
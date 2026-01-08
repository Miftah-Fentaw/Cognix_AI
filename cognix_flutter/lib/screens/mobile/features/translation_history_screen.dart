import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../services/history_service.dart';
import '../../../../models/translation_model.dart';

class TranslationHistoryScreen extends StatefulWidget {
  const TranslationHistoryScreen({super.key});

  @override
  State<TranslationHistoryScreen> createState() =>
      _TranslationHistoryScreenState();
}

class _TranslationHistoryScreenState extends State<TranslationHistoryScreen> {
  late Future<List<Translation>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = HistoryService.getTranslationHistory();
  }

  void _refreshHistory() {
    setState(() {
      _historyFuture = HistoryService.getTranslationHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text('Translation History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline,color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear History?'),
                  content: const Text(
                      'This will remove all saved translations locally.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await HistoryService.clearTranslationHistory();
                        Navigator.pop(context);
                        _refreshHistory();
                      },
                      child: const Text('Clear',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Translation>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final history = snapshot.data ?? [];

          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history,
                      size: 64, color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No translation history yet',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Card(
                elevation: 2,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Chip(
                                label: Text(item.sourceLang,
                                    style: const TextStyle(fontSize: 12)),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                              const Icon(Icons.arrow_right_alt,
                                  color: Colors.grey),
                              Chip(
                                label: Text(item.targetLang,
                                    style: const TextStyle(fontSize: 12)),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: item.translatedText));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Translation copied'),
                                    duration: Duration(seconds: 1)),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(item.text, style: const TextStyle(fontSize: 16)),
                      const Divider(height: 24),
                      Text(
                        item.translatedText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

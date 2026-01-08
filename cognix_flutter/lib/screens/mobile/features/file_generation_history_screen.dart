import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../services/history_service.dart';
import '../../../../models/generated_file_model.dart';

class FileGenerationHistoryScreen extends StatefulWidget {
  const FileGenerationHistoryScreen({super.key});

  @override
  State<FileGenerationHistoryScreen> createState() =>
      _FileGenerationHistoryScreenState();
}

class _FileGenerationHistoryScreenState
    extends State<FileGenerationHistoryScreen> {
  late Future<List<GeneratedFile>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = HistoryService.getGeneratedFileHistory();
  }

  void _refreshHistory() {
    setState(() {
      _historyFuture = HistoryService.getGeneratedFileHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generation History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear History?'),
                  content: const Text(
                      'This will remove all saved generated content.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await HistoryService.clearGeneratedFileHistory();
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
      body: FutureBuilder<List<GeneratedFile>>(
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
                  Icon(Icons.auto_awesome_motion,
                      size: 64, color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No generated content history',
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
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Icon(
                      item.type == 'summary' ? Icons.summarize : Icons.note,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(item.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                    item.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to details or show bottom sheet
                    // For now, let's show a dialog or simple viewer
                    // Or if it matches NotesScreen format, use that.
                    // Assuming generic view for now.

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(title: Text(item.title)),
                          body: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: SelectableText(item.content),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

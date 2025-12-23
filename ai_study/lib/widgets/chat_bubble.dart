import 'package:cognix/screens/mobile/features/notes_screen.dart';
import 'package:cognix/screens/mobile/features/qa_screen.dart';
import 'package:cognix/screens/mobile/features/summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cognix/model/chat_message.dart';


class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = message.isUser;

    if (isUser) {
      return _buildUserBubble(context, isDark);
    }

    return _buildAiBubble(context, isDark, message.text);
  }

  Widget _buildUserBubble(BuildContext context, bool isDark) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.25),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15.5,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildAiBubble(BuildContext context, bool isDark, String rawText) {
    final sections = _parseSections(rawText);

    final summaryContent = sections.firstWhere(
      (s) => s['title']!.contains('Summary'),
      orElse: () => {'content': ''},
    )['content'] ?? '';

    final notesContent = sections.firstWhere(
      (s) => s['title']!.contains('Notes'),
      orElse: () => {'content': ''},
    )['content'] ?? '';

    final qaContent = sections.firstWhere(
      (s) => s['title']!.contains('Q&A'),
      orElse: () => {'content': ''},
    )['content'] ?? '';

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey.shade800, Colors.grey.shade800]
                : [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(6),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color.fromARGB(255, 2, 38, 68),
                  child: Image.asset("assets/cognix.png",),
                ),
                SizedBox(width: 10),
                Text(
                  'Cognix',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSectionIcon(
                  context,
                  icon: Icons.summarize,
                  label: 'Summary',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SummaryScreen(content: summaryContent),
                      ),
                    );
                  },
                ),
                _buildSectionIcon(
                  context,
                  icon: Icons.notes,
                  label: 'Notes',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotesScreen(content: notesContent),
                      ),
                    );
                  },
                ),
                _buildSectionIcon(
                  context,
                  icon: Icons.question_answer,
                  label: 'Q&A',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QAScreen(content: qaContent),
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 12),
            Text(
              'Just now',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionIcon(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blue.shade500, Colors.blue.shade600],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _parseSections(String text) {
    final sections = <Map<String, String>>[];
    final lines = text.split('\n');
    String currentTitle = '';
    String currentContent = '';

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (trimmed.startsWith('📘') || trimmed.contains('Summary:')) {
        if (currentTitle.isNotEmpty) {
          sections.add({'title': currentTitle, 'content': currentContent.trim()});
        }
        currentTitle = '📘 Summary';
        currentContent = '';
      } else if (trimmed.startsWith('📝') || trimmed.contains('Notes:')) {
        if (currentTitle.isNotEmpty) {
          sections.add({'title': currentTitle, 'content': currentContent.trim()});
        }
        currentTitle = '📝 Short Notes';
        currentContent = '';
      } else if (trimmed.startsWith('❓') || trimmed.contains('Q&A:')) {
        if (currentTitle.isNotEmpty) {
          sections.add({'title': currentTitle, 'content': currentContent.trim()});
        }
        currentTitle = '❓ Q&A';
        currentContent = '';
      } else {
        currentContent += '$line\n';
      }
    }

    if (currentTitle.isNotEmpty) {
      sections.add({'title': currentTitle, 'content': currentContent.trim()});
    }

    return sections;
  }
}
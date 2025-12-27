// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cognix/config/router.dart';
import 'package:cognix/services/chat_history_service.dart';
import 'package:intl/intl.dart';

class ChatHistoryScreen extends StatefulWidget {
  final Function(ChatSession) onChatSelected;

  const ChatHistoryScreen({super.key, required this.onChatSelected});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final ChatHistoryService _historyService = ChatHistoryService();
  List<ChatSession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final sessions = await _historyService.getHistory();
    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  Future<void> _deleteChat(String id) async {
    await _historyService.deleteChat(id);
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Chat History',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home);
              }
            },
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.6)),
            ),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white))
                : _sessions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_toggle_off,
                                size: 64, color: Colors.white38),
                            const SizedBox(height: 16),
                            Text(
                              'No history yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                            16, 100, 16, 16), // Top padding for AppBar
                        itemCount: _sessions.length,
                        itemBuilder: (context, index) {
                          final session = _sessions[index];
                          return Dismissible(
                            key: Key(session.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red.withOpacity(0.8),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              _deleteChat(session.id);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.1)),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  session.preview,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Icon(Icons.access_time,
                                          size: 14, color: Colors.white54),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateFormat.yMMMd()
                                            .add_jm()
                                            .format(session.timestamp),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right,
                                    color: Colors.white38),
                                onTap: () {
                                  widget.onChatSelected(session);
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ));
  }
}

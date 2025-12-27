import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cognix/models/chat_message.dart';
import 'package:cognix/widgets/chat_bubble.dart';
import 'package:cognix/widgets/chat_drawer.dart';
import 'dart:ui';

class WebHome extends StatefulWidget {
  const WebHome({super.key});

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
      _controller.clear();
    });

    _focusNode.unfocus();

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _messages.add(
        ChatMessage(
          text: '📘 Summary:\nThis is a generated academic summary.\n\n'
              '📝 Notes:\n• Key idea one\n• Key idea two\n\n'
              '❓ Q&A:\nQ: What is the topic?\nA: The topic is...',
          isUser: false,
        ),
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ChatDrawer(
        // onNewChat: () {
        //   setState(() => _messages.clear());
        //   Navigator.pop(context);
        // },
        onShowHistory: () {
          // Web history not implemented yet
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('History not available on web yet')),
          );
        },
        onResumeHistory: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Resume History not available on web yet')),
          );
        },
        onShowSettings: () {
          // Web settings not implemented yet
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings not available on web yet')),
          );
        },
      ),
      body: Stack(
        children: [
          // Full-screen background image
          Positioned.fill(
            child: Image.asset(
              'assets/web_bkg.png',
              fit: BoxFit.cover,
            ),
          ),

          // Main content
          Column(
            children: [
              // Transparent AppBar
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text('Cognix'),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),

              // Centered chat area with glass effect
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.18),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: _messages.isEmpty
                                      ? _buildEmptyState()
                                      : ListView.builder(
                                          padding: const EdgeInsets.all(24),
                                          itemCount: _messages.length,
                                          itemBuilder: (context, index) {
                                            return ChatBubble(
                                                message: _messages[index]);
                                          },
                                        ),
                                ),
                                if (_isLoading)
                                  const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white70),
                                    ),
                                  ),
                                _buildInputBar(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/cognix.png",
            height: 140,
          ),
          const SizedBox(height: 32),
          const Text(
            'Paste your notes or ask anything...',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.white70),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File upload coming soon')),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              minLines: 1,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Paste your notes or ask anything...',
                hintStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.white.withOpacity(0.12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _isLoading ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}

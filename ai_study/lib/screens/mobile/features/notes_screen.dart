import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class NotesScreen extends StatefulWidget {
  final List<String> notes;

  const NotesScreen({super.key, required this.notes});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.notes.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 50)),
        vsync: this,
      ),
    );
    _animations = _controllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.easeOutBack);
    }).toList();

    // Start animations
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<String> get filteredNotes {
    if (_searchQuery.isEmpty) return widget.notes;
    return widget.notes
        .where(
            (note) => note.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayNotes = filteredNotes;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar(
            expandedHeight: 60,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                '📝 Detailed Notes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:  [Colors.green.shade400, Colors.white70],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Share All',
                onPressed: () {
                  final allNotes = widget.notes
                      .asMap()
                      .entries
                      .map((e) => '${e.key + 1}. ${e.value}')
                      .join('\n\n');
                  Share.share(allNotes, subject: 'Notes from Cognix');
                },
              ),
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy All',
                onPressed: () {
                  final allNotes = widget.notes
                      .asMap()
                      .entries
                      .map((e) => '${e.key + 1}. ${e.value}')
                      .join('\n\n');
                  Clipboard.setData(ClipboardData(text: allNotes));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('All notes copied!'),
                        ],
                      ),
                      backgroundColor: Colors.green.shade600,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [Colors.grey.shade900, Colors.black]
                      : [Colors.grey.shade50, Colors.white],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    prefixIcon: Icon(
                      Icons.search,
                      color:
                          isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Notes count
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? Colors.black : Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                '${displayNotes.length} ${displayNotes.length == 1 ? 'note' : 'notes'}',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Notes list
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final noteIndex = widget.notes.indexOf(displayNotes[index]);
                  final animation = noteIndex < _animations.length
                      ? _animations[noteIndex]
                      : AlwaysStoppedAnimation(1.0);

                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: _buildNoteCard(
                        context,
                        displayNotes[index],
                        noteIndex,
                        isDark,
                      ),
                    ),
                  );
                },
                childCount: displayNotes.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteCard(
      BuildContext context, String note, int index, bool isDark) {
    // Icon based on note index
    final icons = [
      Icons.lightbulb_outline,
      Icons.star_outline,
      Icons.bookmark_outline,
      Icons.flag_outlined,
      Icons.favorite_outline,
      Icons.emoji_objects_outlined,
      Icons.tips_and_updates_outlined,
      Icons.psychology_outlined,
      Icons.school_outlined,
      Icons.science_outlined,
      Icons.auto_awesome_outlined,
      Icons.celebration_outlined,
      Icons.workspace_premium_outlined,
      Icons.verified_outlined,
      Icons.diamond_outlined,
    ];
    final icon = icons[index % icons.length];

    // Gradient colors based on index
    final gradientColors = [
      [Colors.blue.shade600, Colors.blue.shade800],
      [Colors.purple.shade600, Colors.purple.shade800],
      [Colors.green.shade600, Colors.green.shade800],
      [Colors.orange.shade600, Colors.orange.shade800],
      [Colors.pink.shade600, Colors.pink.shade800],
      [Colors.teal.shade600, Colors.teal.shade800],
      [Colors.indigo.shade600, Colors.indigo.shade800],
      [Colors.red.shade600, Colors.red.shade800],
      [Colors.cyan.shade600, Colors.cyan.shade800],
      [Colors.amber.shade600, Colors.amber.shade800],
    ];
    final colors = gradientColors[index % gradientColors.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key('note_$index'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.blue.shade600,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.copy, color: Colors.white),
        ),
        confirmDismiss: (direction) async {
          Clipboard.setData(ClipboardData(text: note));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Note ${index + 1} copied!'),
              backgroundColor: Colors.blue.shade600,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
          return false; // Don't actually dismiss
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              width: 2,
              color: colors[0].withOpacity(0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number badge with gradient
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: colors,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: colors[0].withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: Colors.white, size: 20),
                      const SizedBox(height: 2),
                      Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Note content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Swipe left to copy',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? Colors.grey.shade500
                              : Colors.grey.shade500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

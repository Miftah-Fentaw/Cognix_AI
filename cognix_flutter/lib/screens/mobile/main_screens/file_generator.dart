// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:cognix/models/chat_message.dart';
import 'package:cognix/services/chat_history_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class PremiumFeature extends StatefulWidget {
  const PremiumFeature({super.key});

  @override
  State<PremiumFeature> createState() => _PremiumFeatureState();
}

class _PremiumFeatureState extends State<PremiumFeature> {
  final TextEditingController _topicController = TextEditingController();
  final ChatHistoryService _historyService = ChatHistoryService();
  double _pageCount = 10;
  bool _isLoading = false;
  String? _statusMessage;
  String? _generatedFilePath; // Path to succesful PDF

  final String finegenerating = 'http://10.230.37.240:8000/api/generate-pdf/';

  Future<void> _generateStudyMaterial() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a topic or content')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = "Consulting AI architect...";
      _generatedFilePath = null;
    });

    try {
      // send request for file generation
      final url = Uri.parse(finegenerating);

      // Simulate progress updates for better UX during long wait
      _simulateProgress();

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': topic.length > 30 ? '${topic.substring(0, 30)}...' : topic,
          'content': topic,
          'pages': _pageCount.toInt(),
        }),
      );

      if (response.statusCode == 200) {
        setState(() => _statusMessage = "Finalizing PDF...");

        // 2. Save File
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final safeTopic = topic
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .trim()
            .replaceAll(' ', '_');
        final fileName =
            'Study_Guide_${safeTopic.length > 20 ? safeTopic.substring(0, 20) : safeTopic}_$timestamp.pdf';

        final file = File('${dir.path}/$fileName');

        await file.writeAsBytes(bytes, flush: true);

        // 3. Save to History
        await _saveToHistory(topic, file.path);

        // 4. Update UI to Show Success
        setState(() {
          _isLoading = false;
          _statusMessage = null;
          _generatedFilePath = file.path;
        });
      } else {
        throw Exception(
            'Server returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = null;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"))
            ],
          ),
        );
      }
    }
  }

  Future<void> _saveToHistory(String topic, String filePath) async {
    final sessionId = const Uuid().v4();

    // Create a special message representing this file
    final message = ChatMessage(
      text: "Generated Study Package: $topic",
      isUser: false,
      filePath: filePath,
      fileType: 'pdf',
    );

    final session = ChatSession(
      id: sessionId,
      timestamp: DateTime.now(),
      preview: "Premium Guide: $topic",
      messages: [message],
    );

    await _historyService.saveChat(session);
  }

  void _simulateProgress() async {
    final steps = [
      "Consulting AI architect...",
      "Drafting structure...",
      "Expanding core concepts...",
      "Adding detailed examples...",
      "Formating document...",
      "Generating PDF..."
    ];

    for (var i = 0; i < steps.length; i++) {
      if (!_isLoading) return;
      await Future.delayed(const Duration(seconds: 4));
      if (mounted && _isLoading) {
        setState(() => _statusMessage = steps[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              if (_generatedFilePath != null)
                _buildSuccessView()
              else ...[
                _buildInputSection(),
                const SizedBox(height: 24),
                _buildSliderSection(),
                const SizedBox(height: 40),
                _buildGenerateButton(),
              ],
              if (_isLoading) ...[
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        _statusMessage ?? "Processing...",
                        style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          Text(
            "Study Package Ready!",
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your custom study material has been generated and saved to your history.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          // ACTIONS
          _buildActionButton(
            label: "Open PDF",
            icon: Icons.visibility,
            color: Colors.black87,
            onTap: () => OpenFile.open(_generatedFilePath),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            label: "Share / Save",
            icon: Icons.share,
            color: Colors.blue[700]!,
            onTap: () => Share.shareXFiles([XFile(_generatedFilePath!)],
                text: 'Here is my study guide!'),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              setState(() {
                _generatedFilePath = null;
                _topicController.clear();
              });
            },
            child: Text("Create Another",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.amber[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.amber),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                "PREMIUM",
                style: GoogleFonts.inter(
                  color: Colors.amber[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Generate Comprehensive\nStudy Packages",
          style: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter a topic and let our AI create a detailed 10-15 page study guide for you.",
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TOPIC OR CONTENT",
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _topicController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
                  "e.g., The French Revolution, Quantum Mechanics basics, or paste your rough notes here...",
              hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "TARGET LENGTH",
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
                letterSpacing: 1.2,
              ),
            ),
            Text(
              "${_pageCount.toInt()} Pages",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue[600],
            inactiveTrackColor: Colors.blue[100],
            thumbColor: Colors.white,
            overlayColor: Colors.blue.withOpacity(0.1),
            thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 12, elevation: 4),
            trackHeight: 6,
          ),
          child: Slider(
            value: _pageCount,
            min: 10,
            max: 15,
            divisions: 5,
            onChanged: (value) => setState(() => _pageCount = value),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("10 pgs",
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
              Text("15 pgs",
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _generateStudyMaterial,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, color: Colors.amber),
            const SizedBox(width: 12),
            Text(
              "Generate Study Guide",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

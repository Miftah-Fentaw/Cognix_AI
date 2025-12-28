import 'dart:convert';
import 'dart:io';

import 'package:cognix/models/chat_message.dart';
import 'package:cognix/services/chat_history_service.dart';
import 'package:cognix/widgets/file_generator/generate_button.dart';
import 'package:cognix/widgets/file_generator/length_slider_section.dart';
import 'package:cognix/widgets/file_generator/premium_header.dart';
import 'package:cognix/widgets/file_generator/success_view.dart';
import 'package:cognix/widgets/file_generator/topic_input_section.dart';
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
  String? _generatedFilePath; // Path to successful PDF

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
              const PremiumHeader(),
              const SizedBox(height: 32),
              if (_generatedFilePath != null)
                SuccessView(
                  generatedFilePath: _generatedFilePath!,
                  onOpenPDF: () => OpenFile.open(_generatedFilePath),
                  onShare: () => Share.shareXFiles([XFile(_generatedFilePath!)],
                      text: 'Here is my study guide!'),
                  onCreateAnother: () {
                    setState(() {
                      _generatedFilePath = null;
                      _topicController.clear();
                    });
                  },
                )
              else ...[
                TopicInputSection(controller: _topicController),
                const SizedBox(height: 24),
                LengthSliderSection(
                  pageCount: _pageCount,
                  onChanged: (value) => setState(() => _pageCount = value),
                ),
                const SizedBox(height: 40),
                GenerateButton(
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _generateStudyMaterial,
                ),
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
}

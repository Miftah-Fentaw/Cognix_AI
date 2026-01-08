import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/resume_service.dart';
import '../../../widgets/resume_history/resume_history_header.dart';
import '../../../widgets/resume_history/resume_history_item_card.dart';
import '../../../widgets/resume_history/empty_history_view.dart';

class ResumeHistoryScreen extends StatefulWidget {
  const ResumeHistoryScreen({super.key});

  @override
  State<ResumeHistoryScreen> createState() => _ResumeHistoryScreenState();
}

class _ResumeHistoryScreenState extends State<ResumeHistoryScreen> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final history = await ResumeService.getResumeHistory();
      setState(() {
        _history = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage('Failed to load history: $e');
    }
  }

  Future<void> _viewResume(Map<String, dynamic> resume) async {
    try {
      final localPath = resume['localPath'];
      if (localPath != null && await File(localPath).exists()) {
        await ResumeService.viewPDF(localPath);
      } else {
        _showErrorMessage('Resume file not found locally');
      }
    } catch (e) {
      _showErrorMessage('Failed to open resume: $e');
    }
  }

  Future<void> _shareResume(Map<String, dynamic> resume) async {
    try {
      final localPath = resume['localPath'];
      if (localPath != null && await File(localPath).exists()) {
        await ResumeService.sharePDF(localPath, resume['name'] ?? 'Resume');
      } else {
        _showErrorMessage('Resume file not found locally');
      }
    } catch (e) {
      _showErrorMessage('Failed to share resume: $e');
    }
  }

  Future<void> _deleteResume(Map<String, dynamic> resume) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Resume',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete this resume? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ResumeService.deleteFromHistory(resume['id']);
      if (success) {
        _showSuccessMessage('Resume deleted successfully');
        _loadHistory(); // Refresh the list
      } else {
        _showErrorMessage('Failed to delete resume');
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            ResumeHistoryHeader(onRefresh: _loadHistory),
            // Content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    )
                  : _history.isEmpty
                      ? const EmptyHistoryView()
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _history.length,
                          itemBuilder: (context, index) {
                            final resume = _history[index];
                            return ResumeHistoryItemCard(
                              resume: resume,
                              onView: () => _viewResume(resume),
                              onShare: () => _shareResume(resume),
                              onDelete: (_) => _deleteResume(resume),
                              formatDate: _formatDate,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

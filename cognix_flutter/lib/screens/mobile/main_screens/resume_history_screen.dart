import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/resume_service.dart';

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
        title: Text(
          'Delete Resume',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this resume? This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.outfit()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
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
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.history, color: Colors.orange, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resume History',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Your generated resumes',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.orange),
                    onPressed: _loadHistory,
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    )
                  : _history.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No resumes yet',
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Generate your first resume to see it here',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _history.length,
                          itemBuilder: (context, index) {
                            final resume = _history[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                            color: Colors.orange.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.picture_as_pdf,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                resume['name'] ?? 'Unknown',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              if (resume['jobTitle'] != null && resume['jobTitle'].isNotEmpty)
                                                Text(
                                                  resume['jobTitle'],
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          onSelected: (value) {
                                            switch (value) {
                                              case 'view':
                                                _viewResume(resume);
                                                break;
                                              case 'share':
                                                _shareResume(resume);
                                                break;
                                              case 'delete':
                                                _deleteResume(resume);
                                                break;
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'view',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.visibility, size: 18),
                                                  const SizedBox(width: 8),
                                                  Text('View', style: GoogleFonts.inter()),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'share',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.share, size: 18),
                                                  const SizedBox(width: 8),
                                                  Text('Share', style: GoogleFonts.inter()),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete, size: 18, color: Colors.red),
                                                  const SizedBox(width: 8),
                                                  Text('Delete', style: GoogleFonts.inter(color: Colors.red)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Created: ${_formatDate(resume['createdAt'] ?? '')}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.check_circle, size: 12, color: Colors.green),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Available',
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: () => _viewResume(resume),
                                            icon: Icon(Icons.visibility, size: 16),
                                            label: Text(
                                              'View',
                                              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: () => _shareResume(resume),
                                            icon: Icon(Icons.share, size: 16),
                                            label: Text(
                                              'Share',
                                              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.orange,
                                              side: BorderSide(color: Colors.orange),
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
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
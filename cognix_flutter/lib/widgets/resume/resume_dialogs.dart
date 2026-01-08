import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/resume_service.dart';

/// Show a hint/tip dialog
void showResumeHintDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.orange, size: 24),
          const SizedBox(width: 12),
          Text(
            'Tip',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: GoogleFonts.inter(fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.orange,
          ),
          child: Text(
            'Got it',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
          ),
        )
      ],
    ),
  );
}

/// Show resume generated success dialog
void showResumeGeneratedDialog({
  required BuildContext context,
  required String pdfPath,
  required String fileName,
  required VoidCallback onCreateAnother,
  required Function(String) onError,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.check_circle, color: Colors.green, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Resume Generated!',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your professional resume has been generated successfully and saved to your device.',
            style: GoogleFonts.inter(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'You can view your resume history anytime from the main menu.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onCreateAnother();
          },
          child: Text(
            'Create Another',
            style: GoogleFonts.outfit(color: Colors.grey[600]),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            Navigator.pop(context);
            try {
              await ResumeService.viewPDF(pdfPath);
            } catch (e) {
              onError('Failed to open PDF: $e');
            }
          },
          icon: const Icon(Icons.visibility, size: 16),
          label: Text(
            'View Resume',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            Navigator.pop(context);
            try {
              await ResumeService.sharePDF(pdfPath, fileName);
            } catch (e) {
              onError('Failed to share PDF: $e');
            }
          },
          icon: const Icon(Icons.share, size: 16),
          label: Text(
            'Share',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Show success message snackbar
void showResumeSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

/// Show error message snackbar
void showResumeErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

/// Show loading dialog
void showResumeLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      child: CircularProgressIndicator(color: Colors.orange),
    ),
  );
}

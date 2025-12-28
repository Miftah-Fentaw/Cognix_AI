import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessView extends StatelessWidget {
  final String generatedFilePath;
  final VoidCallback onOpenPDF;
  final VoidCallback onShare;
  final VoidCallback onCreateAnother;

  const SuccessView({
    super.key,
    required this.generatedFilePath,
    required this.onOpenPDF,
    required this.onShare,
    required this.onCreateAnother,
  });

  @override
  Widget build(BuildContext context) {
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
            onTap: onOpenPDF,
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            label: "Share / Save",
            icon: Icons.share,
            color: Colors.blue[700]!,
            onTap: onShare,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onCreateAnother,
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
}

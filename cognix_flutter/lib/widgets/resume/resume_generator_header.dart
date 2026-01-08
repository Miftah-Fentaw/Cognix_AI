import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ResumeGeneratorHeader extends StatelessWidget {
  final VoidCallback onHistoryPressed;
  final VoidCallback onSaveDraftPressed;
  final VoidCallback onLoadDraftPressed;
  final VoidCallback onHelpPressed;

  const ResumeGeneratorHeader({
    super.key,
    required this.onHistoryPressed,
    required this.onSaveDraftPressed,
    required this.onLoadDraftPressed,
    required this.onHelpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
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
          Align(
              alignment: Alignment.topLeft,
               child: IconButton(
                         icon: const Icon(Icons.arrow_back,color: Colors.black,),
                         onPressed: () => context.pushReplacement('/'),
                       ),
             ),
             SizedBox(width: 5,),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Image.asset('assets/icons/robot.png', width: 24, height: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resume Generator',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Create a professional resume in minutes',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.orange),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              switch (value) {
                case 'history':
                  onHistoryPressed();
                  break;
                case 'save_draft':
                  onSaveDraftPressed();
                  break;
                case 'load_draft':
                  onLoadDraftPressed();
                  break;
                case 'help':
                  onHelpPressed();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'history',
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 18),
                    const SizedBox(width: 8),
                    Text('Resume History', style: GoogleFonts.inter()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'save_draft',
                child: Row(
                  children: [
                    const Icon(Icons.save, size: 18),
                    const SizedBox(width: 8),
                    Text('Save Draft', style: GoogleFonts.inter()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'load_draft',
                child: Row(
                  children: [
                    const Icon(Icons.folder_open, size: 18),
                    const SizedBox(width: 8),
                    Text('Load Draft', style: GoogleFonts.inter()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    const Icon(Icons.help_outline, size: 18),
                    const SizedBox(width: 8),
                    Text('Help', style: GoogleFonts.inter()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

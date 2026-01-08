import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FileGeneratorHeader extends StatelessWidget {
  const FileGeneratorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                 child: IconButton(
                           icon: const Icon(Icons.arrow_back,color: Colors.black,),
                           onPressed: () => context.pushReplacement('/'),
                         ),
               ),
               SizedBox(width: 10,),
              Text(
                "Generate Comprehensive\nStudy Packages",
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Enter a topic and let our AI create a detailed 10-15 page study guide for you.",
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

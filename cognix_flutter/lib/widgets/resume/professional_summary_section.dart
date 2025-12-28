import 'package:flutter/material.dart';
import './resume_section.dart';
import './resume_input_field.dart';

class ProfessionalSummarySection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onShowTip;

  const ProfessionalSummarySection({
    super.key,
    required this.controller,
    required this.onShowTip,
  });

  @override
  Widget build(BuildContext context) {
    return ResumeSection(
      title: 'Professional Summary',
      subtitle: 'Brief overview of your experience and goals',
      icon: Icons.description_outlined,
      tipMessage:
          'Write 2-3 sentences highlighting your key skills, experience, and career goals. Focus on what makes you unique and valuable to employers. Use action words and quantify achievements when possible.',
      onTipPressed: onShowTip,
      child: ResumeInputField(
        label: 'Summary',
        hint:
            'Experienced software developer with 5+ years in mobile app development...',
        controller: controller,
        maxLines: 4,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Professional summary is required';
          }
          return null;
        },
      ),
    );
  }
}

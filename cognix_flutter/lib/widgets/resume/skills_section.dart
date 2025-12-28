import 'package:flutter/material.dart';
import './resume_section.dart';
import './resume_input_field.dart';

class SkillsSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onShowTip;

  const SkillsSection({
    super.key,
    required this.controller,
    required this.onShowTip,
  });

  @override
  Widget build(BuildContext context) {
    return ResumeSection(
      title: 'Skills',
      subtitle: 'Your technical and professional skills',
      icon: Icons.psychology_outlined,
      tipMessage:
          'List skills relevant to the job you\'re applying for. Separate technical skills from soft skills. Be honest about your skill level - only include skills you can confidently discuss in an interview.',
      onTipPressed: onShowTip,
      child: ResumeInputField(
        label: 'Skills',
        hint: 'Flutter, Dart, JavaScript, React, Node.js, Python',
        controller: controller,
      ),
    );
  }
}

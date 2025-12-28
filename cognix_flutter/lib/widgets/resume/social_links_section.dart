import 'package:flutter/material.dart';
import './resume_section.dart';
import './resume_input_field.dart';

class SocialLinksSection extends StatelessWidget {
  final TextEditingController linkedinController;
  final TextEditingController githubController;
  final TextEditingController portfolioController;
  final VoidCallback onShowTip;

  const SocialLinksSection({
    super.key,
    required this.linkedinController,
    required this.githubController,
    required this.portfolioController,
    required this.onShowTip,
  });

  @override
  Widget build(BuildContext context) {
    return ResumeSection(
      title: 'Professional Links',
      subtitle: 'Your online presence and portfolio',
      icon: Icons.link_outlined,
      tipMessage:
          'Add only professional and relevant links. Make sure your LinkedIn profile is complete and up-to-date. Include your best projects on GitHub and portfolio website.',
      onTipPressed: onShowTip,
      child: Column(
        children: [
          ResumeInputField(
            label: 'LinkedIn Profile',
            hint: 'linkedin.com/in/sample',
            icon: Icons.business_center_outlined,
            controller: linkedinController,
          ),
          const SizedBox(height: 16),
          ResumeInputField(
            label: 'GitHub Profile',
            hint: 'github.com/sample',
            icon: Icons.code_outlined,
            controller: githubController,
          ),
          const SizedBox(height: 16),
          ResumeInputField(
            label: 'Portfolio Website',
            hint: 'sample.com',
            icon: Icons.public_outlined,
            controller: portfolioController,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../models/resume_models.dart';
import '../../../services/resume_service.dart';
import '../../../widgets/resume/resume_generator_header.dart';
import '../../../widgets/resume/social_links_section.dart';
import '../../../widgets/resume/professional_summary_section.dart';
import '../../../widgets/resume/skills_section.dart';
import '../../../widgets/resume/resume_action_buttons.dart';
import '../../../widgets/resume/personal_info_widget.dart';
import '../../../widgets/resume/work_experience_widget.dart';
import '../../../widgets/resume/education_widget.dart';
import '../../../widgets/resume/certifications_widget.dart';
import 'resume_history_screen.dart';

class ResumeGenerator extends StatefulWidget {
  const ResumeGenerator({super.key});

  @override
  State<ResumeGenerator> createState() => _ResumeGeneratorState();
}

class _ResumeGeneratorState extends State<ResumeGenerator> {
  final _formKey = GlobalKey<FormState>();
  late ResumeData _resumeData;
  bool _isGenerating = false;

  // Controllers for simple fields
  final _linkedinController = TextEditingController();
  final _githubController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _summaryController = TextEditingController();
  final _skillsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resumeData = ResumeData();
    _initializeControllers();
  }

  void _initializeControllers() {
    _linkedinController.text = _resumeData.socialLinks.linkedin;
    _githubController.text = _resumeData.socialLinks.github;
    _portfolioController.text = _resumeData.socialLinks.portfolio;
    _summaryController.text = _resumeData.professionalSummary;
    _skillsController.text = _resumeData.skills;

    // Add listeners
    _linkedinController.addListener(() {
      _resumeData.socialLinks.linkedin = _linkedinController.text;
    });
    _githubController.addListener(() {
      _resumeData.socialLinks.github = _githubController.text;
    });
    _portfolioController.addListener(() {
      _resumeData.socialLinks.portfolio = _portfolioController.text;
    });
    _summaryController.addListener(() {
      _resumeData.professionalSummary = _summaryController.text;
    });
    _skillsController.addListener(() {
      _resumeData.skills = _skillsController.text;
    });
  }

  @override
  void dispose() {
    _linkedinController.dispose();
    _githubController.dispose();
    _portfolioController.dispose();
    _summaryController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _showHint(String message) {
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

  Future<void> _uploadPhoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        // Show loading
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          );
        }

        final response = await ResumeService.uploadPhoto(file);
        if (mounted) Navigator.pop(context); // Close loading

        if (response['success']) {
          setState(() {
            _resumeData.personalInfo.photoPath = response['photoUrl'];
          });
          _showSuccessMessage('Photo uploaded successfully!');
        } else {
          _showErrorMessage(response['message'] ?? 'Failed to upload photo');
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading if open
      _showErrorMessage('Error selecting photo: $e');
    }
  }

  Future<void> _generateResume() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorMessage('Please fill in all required fields');
      return;
    }

    // Validate resume data
    final validation = ResumeService.validateResumeData(_resumeData);
    if (!validation['isValid']) {
      _showErrorMessage(
          'Please complete the following:\n${validation['errors'].join('\n')}');
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final response = await ResumeService.generateResume(_resumeData);

      if (response['success']) {
        // Clear draft since resume is generated
        await ResumeService.clearDraft();

        // Show success dialog with options
        if (mounted) {
          _showResumeGeneratedDialog(
              response['pdfPath'], _resumeData.personalInfo.fullName);
        }
      } else {
        _showErrorMessage(response['message'] ?? 'Failed to generate resume');
      }
    } catch (e) {
      _showErrorMessage('Error generating resume: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _showResumeGeneratedDialog(String pdfPath, String fileName) {
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
              _resetForm();
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
                _showErrorMessage('Failed to open PDF: $e');
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
                _showErrorMessage('Failed to share PDF: $e');
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

  void _resetForm() {
    setState(() {
      _resumeData = ResumeData();
      _initializeControllers();
    });
    _formKey.currentState?.reset();
  }

  Future<void> _saveDraft() async {
    final success = await ResumeService.saveResumeLocally(_resumeData);
    if (success) {
      _showSuccessMessage('Draft saved successfully');
    } else {
      _showErrorMessage('Failed to save draft');
    }
  }

  Future<void> _loadDraft() async {
    final draft = await ResumeService.loadResumeLocally();
    if (draft != null) {
      setState(() {
        _resumeData = draft;
        _initializeControllers();
      });
      _showSuccessMessage('Draft loaded successfully');
    } else {
      _showErrorMessage('No draft found');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            ResumeGeneratorHeader(
              onHistoryPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResumeHistoryScreen(),
                  ),
                );
              },
              onSaveDraftPressed: _saveDraft,
              onLoadDraftPressed: _loadDraft,
              onHelpPressed: () => _showHint(
                'Fill all sections accurately to generate a professional resume PDF. Use clear, concise language and focus on achievements.',
              ),
            ),

            // Form Content
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Personal Information
                      PersonalInfoWidget(
                        personalInfo: _resumeData.personalInfo,
                        onChanged: (personalInfo) {
                          setState(() {
                            _resumeData.personalInfo = personalInfo;
                          });
                        },
                        onPhotoUpload: _uploadPhoto,
                        onShowTip: () => _showHint(
                          'Use your full legal name as it appears on official documents. Choose a professional job title that matches your target role. Include a professional photo with good lighting and neutral background.',
                        ),
                      ),

                      // Social Links
                      SocialLinksSection(
                        linkedinController: _linkedinController,
                        githubController: _githubController,
                        portfolioController: _portfolioController,
                        onShowTip: () => _showHint(
                          'Add only professional and relevant links. Make sure your LinkedIn profile is complete and up-to-date. Include your best projects on GitHub and portfolio website.',
                        ),
                      ),

                      // Professional Summary
                      ProfessionalSummarySection(
                        controller: _summaryController,
                        onShowTip: () => _showHint(
                          'Write 2-3 sentences highlighting your key skills, experience, and career goals. Focus on what makes you unique and valuable to employers. Use action words and quantify achievements when possible.',
                        ),
                      ),

                      // Work Experience
                      WorkExperienceWidget(
                        workExperiences: _resumeData.workExperiences,
                        onChanged: (experiences) {
                          setState(() {
                            _resumeData.workExperiences = experiences;
                          });
                        },
                        onShowTip: () => _showHint(
                          'List your work experience in reverse chronological order (most recent first). Use bullet points to describe achievements, not just duties. Quantify your impact with numbers, percentages, or specific results whenever possible.',
                        ),
                      ),

                      // Education
                      EducationWidget(
                        educations: _resumeData.educations,
                        onChanged: (educations) {
                          setState(() {
                            _resumeData.educations = educations;
                          });
                        },
                        onShowTip: () => _showHint(
                          'Include your highest degree first, then other relevant education. Mention honors, relevant coursework, or academic achievements if they strengthen your application. Include GPA only if it\'s 3.5 or higher.',
                        ),
                      ),

                      // Skills
                      SkillsSection(
                        controller: _skillsController,
                        onShowTip: () => _showHint(
                          'List skills relevant to the job you\'re applying for. Separate technical skills from soft skills. Be honest about your skill level - only include skills you can confidently discuss in an interview.',
                        ),
                      ),

                      // Certifications
                      CertificationsWidget(
                        certifications: _resumeData.certifications,
                        onChanged: (certifications) {
                          setState(() {
                            _resumeData.certifications = certifications;
                          });
                        },
                        onShowTip: () => _showHint(
                          'Include relevant certifications, professional licenses, awards, or recognitions. Focus on recent certifications (within 3-5 years) unless they\'re evergreen credentials. Include the issuing organization and date.',
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Generate Button
                      ResumeActionButtons(
                        isGenerating: _isGenerating,
                        onGenerate: _generateResume,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

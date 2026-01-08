import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/resume_models.dart';
import '../../../services/resume_form_service.dart';
import '../../../widgets/resume/resume_generator_header.dart';
import '../../../widgets/resume/social_links_section.dart';
import '../../../widgets/resume/professional_summary_section.dart';
import '../../../widgets/resume/skills_section.dart';
import '../../../widgets/resume/resume_action_buttons.dart';
import '../../../widgets/resume/personal_info_widget.dart';
import '../../../widgets/resume/work_experience_widget.dart';
import '../../../widgets/resume/education_widget.dart';
import '../../../widgets/resume/certifications_widget.dart';
import '../../../widgets/resume/resume_dialogs.dart';
import '../features/resume_history_screen.dart';

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
    _resumeData = ResumeFormService.createEmptyResumeData();
    _initializeControllers();
  }

  void _initializeControllers() {
    ResumeFormService.initializeControllers(
      resumeData: _resumeData,
      linkedinController: _linkedinController,
      githubController: _githubController,
      portfolioController: _portfolioController,
      summaryController: _summaryController,
      skillsController: _skillsController,
    );
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

  Future<void> _uploadPhoto() async {
    // Show loading
    if (mounted) {
      showResumeLoadingDialog(context);
    }

    final response = await ResumeFormService.uploadPhoto();
    if (mounted) Navigator.pop(context); // Close loading

    if (response['success']) {
      setState(() {
        _resumeData.personalInfo.photoPath = response['photoUrl'];
      });
      if (mounted) {
        showResumeSuccessMessage(context, 'Photo uploaded successfully!');
      }
    } else {
      if (mounted) {
        showResumeErrorMessage(
            context, response['message'] ?? 'Failed to upload photo');
      }
    }
  }

  Future<void> _generateResume() async {
    if (!_formKey.currentState!.validate()) {
      if (mounted) {
        showResumeErrorMessage(context, 'Please fill in all required fields');
      }
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final response = await ResumeFormService.generateResume(_resumeData);

      if (response['success']) {
        // Show success dialog with options
        if (mounted) {
          showResumeGeneratedDialog(
            context: context,
            pdfPath: response['pdfPath'],
            fileName: _resumeData.personalInfo.fullName,
            onCreateAnother: _resetForm,
            onError: (error) {
              if (mounted) {
                showResumeErrorMessage(context, error);
              }
            },
          );
        }
      } else {
        if (mounted) {
          showResumeErrorMessage(
              context, response['message'] ?? 'Failed to generate resume');
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _resetForm() {
    setState(() {
      _resumeData = ResumeFormService.createEmptyResumeData();
      _initializeControllers();
    });
    _formKey.currentState?.reset();
  }

  Future<void> _saveDraft() async {
    final response = await ResumeFormService.saveDraft(_resumeData);
    if (mounted) {
      if (response['success']) {
        showResumeSuccessMessage(context, response['message']);
      } else {
        showResumeErrorMessage(context, response['message']);
      }
    }
  }

  Future<void> _loadDraft() async {
    final response = await ResumeFormService.loadDraft();
    if (mounted) {
      if (response['success']) {
        setState(() {
          _resumeData = response['data'];
          _initializeControllers();
        });
        showResumeSuccessMessage(context, response['message']);
      } else {
        showResumeErrorMessage(context, response['message']);
      }
    }
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
              onHelpPressed: () => showResumeHintDialog(
                context,
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
                        onShowTip: () => showResumeHintDialog(
                          context,
                          'Use your full legal name as it appears on official documents. Choose a professional job title that matches your target role. Include a professional photo with good lighting and neutral background.',
                        ),
                      ),

                      // Social Links
                      SocialLinksSection(
                        linkedinController: _linkedinController,
                        githubController: _githubController,
                        portfolioController: _portfolioController,
                        onShowTip: () => showResumeHintDialog(
                          context,
                          'Add only professional and relevant links. Make sure your LinkedIn profile is complete and up-to-date. Include your best projects on GitHub and portfolio website.',
                        ),
                      ),

                      // Professional Summary
                      ProfessionalSummarySection(
                        controller: _summaryController,
                        onShowTip: () => showResumeHintDialog(
                          context,
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
                        onShowTip: () => showResumeHintDialog(
                          context,
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
                        onShowTip: () => showResumeHintDialog(
                          context,
                          'Include your highest degree first, then other relevant education. Mention honors, relevant coursework, or academic achievements if they strengthen your application. Include GPA only if it\'s 3.5 or higher.',
                        ),
                      ),

                      // Skills
                      SkillsSection(
                        controller: _skillsController,
                        onShowTip: () => showResumeHintDialog(
                          context,
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
                        onShowTip: () => showResumeHintDialog(
                          context,
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

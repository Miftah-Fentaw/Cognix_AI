import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../../../models/resume_models.dart';
import '../../../services/resume_service.dart';
import '../../../widgets/resume/resume_section.dart';
import '../../../widgets/resume/resume_input_field.dart';
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
            Icon(Icons.lightbulb, color: Colors.orange, size: 24),
            SizedBox(width: 12),
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
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Center(
            child: CircularProgressIndicator(color: Colors.orange),
          ),
        );

        final response = await ResumeService.uploadPhoto(file);
        Navigator.pop(context); // Close loading

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
      Navigator.pop(context); // Close loading if open
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
      _showErrorMessage('Please complete the following:\n${validation['errors'].join('\n')}');
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
        _showResumeGeneratedDialog(response['pdfPath'], _resumeData.personalInfo.fullName);
      } else {
        _showErrorMessage(response['message'] ?? 'Failed to generate resume');
      }
    } catch (e) {
      _showErrorMessage('Error generating resume: $e');
    } finally {
      setState(() {
        _isGenerating = false;
      });
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
              child: Icon(Icons.check_circle, color: Colors.green, size: 24),
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
                  Icon(Icons.info_outline, color: Colors.blue, size: 16),
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
            icon: Icon(Icons.visibility, size: 16),
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
            icon: Icon(Icons.share, size: 16),
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
            // Custom Header
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.description, color: Colors.orange, size: 24),
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
                        icon: Icon(Icons.more_vert, color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 'history':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ResumeHistoryScreen(),
                                ),
                              );
                              break;
                            case 'save_draft':
                              _saveDraft();
                              break;
                            case 'load_draft':
                              _loadDraft();
                              break;
                            case 'help':
                              _showHint(
                                'Fill all sections accurately to generate a professional resume PDF. Use clear, concise language and focus on achievements.',
                              );
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'history',
                            child: Row(
                              children: [
                                Icon(Icons.history, size: 18),
                                const SizedBox(width: 8),
                                Text('Resume History', style: GoogleFonts.inter()),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'save_draft',
                            child: Row(
                              children: [
                                Icon(Icons.save, size: 18),
                                const SizedBox(width: 8),
                                Text('Save Draft', style: GoogleFonts.inter()),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'load_draft',
                            child: Row(
                              children: [
                                Icon(Icons.folder_open, size: 18),
                                const SizedBox(width: 8),
                                Text('Load Draft', style: GoogleFonts.inter()),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'help',
                            child: Row(
                              children: [
                                Icon(Icons.help_outline, size: 18),
                                const SizedBox(width: 8),
                                Text('Help', style: GoogleFonts.inter()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
                      ResumeSection(
                        title: 'Professional Links',
                        subtitle: 'Your online presence and portfolio',
                        icon: Icons.link_outlined,
                        tipMessage: 'Add only professional and relevant links. Make sure your LinkedIn profile is complete and up-to-date. Include your best projects on GitHub and portfolio website.',
                        onTipPressed: () => _showHint(
                          'Add only professional and relevant links. Make sure your LinkedIn profile is complete and up-to-date. Include your best projects on GitHub and portfolio website.',
                        ),
                        child: Column(
                          children: [
                            ResumeInputField(
                              label: 'LinkedIn Profile',
                              hint: 'linkedin.com/in/johndoe',
                              icon: Icons.business_center_outlined,
                              controller: _linkedinController,
                            ),
                            const SizedBox(height: 16),
                            ResumeInputField(
                              label: 'GitHub Profile',
                              hint: 'github.com/johndoe',
                              icon: Icons.code_outlined,
                              controller: _githubController,
                            ),
                            const SizedBox(height: 16),
                            ResumeInputField(
                              label: 'Portfolio Website',
                              hint: 'johndoe.dev',
                              icon: Icons.public_outlined,
                              controller: _portfolioController,
                            ),
                          ],
                        ),
                      ),

                      // Professional Summary
                      ResumeSection(
                        title: 'Professional Summary',
                        subtitle: 'Brief overview of your experience and goals',
                        icon: Icons.description_outlined,
                        tipMessage: 'Write 2-3 sentences highlighting your key skills, experience, and career goals. Focus on what makes you unique and valuable to employers. Use action words and quantify achievements when possible.',
                        onTipPressed: () => _showHint(
                          'Write 2-3 sentences highlighting your key skills, experience, and career goals. Focus on what makes you unique and valuable to employers. Use action words and quantify achievements when possible.',
                        ),
                        child: ResumeInputField(
                          label: 'Summary',
                          hint: 'Experienced software developer with 5+ years in mobile app development...',
                          controller: _summaryController,
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Professional summary is required';
                            }
                            return null;
                          },
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
                      ResumeSection(
                        title: 'Skills',
                        subtitle: 'Your technical and professional skills',
                        icon: Icons.psychology_outlined,
                        tipMessage: 'List skills relevant to the job you\'re applying for. Separate technical skills from soft skills. Be honest about your skill level - only include skills you can confidently discuss in an interview.',
                        onTipPressed: () => _showHint(
                          'List skills relevant to the job you\'re applying for. Separate technical skills from soft skills. Be honest about your skill level - only include skills you can confidently discuss in an interview.',
                        ),
                        child: ResumeInputField(
                          label: 'Skills',
                          hint: 'Flutter, Dart, JavaScript, React, Node.js, Python',
                          controller: _skillsController,
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
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange, Colors.deepOrange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _isGenerating ? null : _generateResume,
                          icon: _isGenerating
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(Icons.picture_as_pdf, size: 20),
                          label: Text(
                            _isGenerating ? 'Generating...' : 'Generate Professional Resume',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your resume will be generated as a clean, professional PDF ready for job applications.',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          ],
                        ),
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

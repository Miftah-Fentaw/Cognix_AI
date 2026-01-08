import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../models/resume_models.dart';
import 'resume_service.dart';

class ResumeFormService {
  /// Upload photo and return the response
  static Future<Map<String, dynamic>> uploadPhoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final response = await ResumeService.uploadPhoto(file);
        return response;
      }

      return {'success': false, 'message': 'No file selected'};
    } catch (e) {
      return {'success': false, 'message': 'Error selecting photo: $e'};
    }
  }

  /// Generate resume with validation
  static Future<Map<String, dynamic>> generateResume(
      ResumeData resumeData) async {
    // Validate resume data
    final validation = ResumeService.validateResumeData(resumeData);
    if (!validation['isValid']) {
      return {
        'success': false,
        'message':
            'Please complete the following:\n${validation['errors'].join('\n')}'
      };
    }

    try {
      final response = await ResumeService.generateResume(resumeData);

      if (response['success']) {
        // Clear draft since resume is generated
        await ResumeService.clearDraft();
      }

      return response;
    } catch (e) {
      return {'success': false, 'message': 'Error generating resume: $e'};
    }
  }

  /// Initialize text controllers with resume data
  static void initializeControllers({
    required ResumeData resumeData,
    required TextEditingController linkedinController,
    required TextEditingController githubController,
    required TextEditingController portfolioController,
    required TextEditingController summaryController,
    required TextEditingController skillsController,
  }) {
    linkedinController.text = resumeData.socialLinks.linkedin;
    githubController.text = resumeData.socialLinks.github;
    portfolioController.text = resumeData.socialLinks.portfolio;
    summaryController.text = resumeData.professionalSummary;
    skillsController.text = resumeData.skills;

    // Add listeners
    linkedinController.addListener(() {
      resumeData.socialLinks.linkedin = linkedinController.text;
    });
    githubController.addListener(() {
      resumeData.socialLinks.github = githubController.text;
    });
    portfolioController.addListener(() {
      resumeData.socialLinks.portfolio = portfolioController.text;
    });
    summaryController.addListener(() {
      resumeData.professionalSummary = summaryController.text;
    });
    skillsController.addListener(() {
      resumeData.skills = skillsController.text;
    });
  }

  /// Save draft
  static Future<Map<String, dynamic>> saveDraft(ResumeData resumeData) async {
    final success = await ResumeService.saveResumeLocally(resumeData);
    return {
      'success': success,
      'message': success ? 'Draft saved successfully' : 'Failed to save draft'
    };
  }

  /// Load draft
  static Future<Map<String, dynamic>> loadDraft() async {
    final draft = await ResumeService.loadResumeLocally();
    if (draft != null) {
      return {
        'success': true,
        'message': 'Draft loaded successfully',
        'data': draft
      };
    }
    return {'success': false, 'message': 'No draft found'};
  }

  /// Create a new empty resume data instance
  static ResumeData createEmptyResumeData() {
    return ResumeData();
  }
}

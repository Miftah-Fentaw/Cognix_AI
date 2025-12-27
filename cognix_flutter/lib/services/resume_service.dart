import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/resume_models.dart';
import '../utils/constants.dart';

class ResumeService {
  /// Generate resume PDF from resume data
  static Future<Map<String, dynamic>> generateResume(ResumeData resumeData) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.resumeGenerateUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(resumeData.toJson()),
      ).timeout(Duration(seconds: AppConstants.connectionTimeout));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Download the PDF file
        final pdfBytes = await _downloadPDF(responseData['pdf_url']);
        if (pdfBytes != null) {
          // Save PDF locally
          final savedPath = await _savePDFLocally(pdfBytes, resumeData.personalInfo.fullName);
          
          // Save to history
          await _saveToHistory(resumeData, savedPath, responseData['pdf_url']);
          
          return {
            'success': true,
            'pdfPath': savedPath,
            'pdfUrl': responseData['pdf_url'],
            'message': 'Resume generated successfully',
          };
        } else {
          return {
            'success': false,
            'error': 'Failed to download PDF',
            'message': 'PDF download failed',
          };
        }
      } else {
        return {
          'success': false,
          'error': 'Failed to generate resume: ${response.statusCode}',
          'message': 'Server error occurred',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Network error occurred. Please check your connection and server IP.',
      };
    }
  }

  /// Download PDF from URL
  static Future<Uint8List?> _downloadPDF(String pdfUrl) async {
    try {
      // Handle relative URLs by prepending base URL if needed
      final fullUrl = pdfUrl.startsWith('http') ? pdfUrl : '${AppConstants.baseUrl}$pdfUrl';
      
      final response = await http.get(Uri.parse(fullUrl))
          .timeout(Duration(seconds: AppConstants.receiveTimeout));
      
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      print('Error downloading PDF: $e');
      return null;
    }
  }

  /// Save PDF to local storage
  static Future<String> _savePDFLocally(Uint8List pdfBytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final resumesDir = Directory('${directory.path}/${AppConstants.resumesFolderName}');
    
    if (!await resumesDir.exists()) {
      await resumesDir.create(recursive: true);
    }
    
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final sanitizedFileName = fileName.replaceAll(RegExp(r'[^\w\s-]'), '').trim();
    final file = File('${resumesDir.path}/${sanitizedFileName}_$timestamp.pdf');
    
    await file.writeAsBytes(pdfBytes);
    return file.path;
  }

  /// Save resume to history
  static Future<void> _saveToHistory(ResumeData resumeData, String localPath, String? onlineUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(AppConstants.resumeHistoryKey) ?? '[]';
      final List<dynamic> history = jsonDecode(historyJson);
      
      final historyItem = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': resumeData.personalInfo.fullName,
        'jobTitle': resumeData.personalInfo.jobTitle,
        'createdAt': DateTime.now().toIso8601String(),
        'localPath': localPath,
        'onlineUrl': onlineUrl,
        'resumeData': resumeData.toJson(),
      };
      
      history.insert(0, historyItem); // Add to beginning
      
      // Keep only last N resumes
      if (history.length > AppConstants.maxResumeHistoryCount) {
        history.removeRange(AppConstants.maxResumeHistoryCount, history.length);
      }
      
      await prefs.setString(AppConstants.resumeHistoryKey, jsonEncode(history));
    } catch (e) {
      print('Error saving to history: $e');
    }
  }

  /// Get resume history
  static Future<List<Map<String, dynamic>>> getResumeHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(AppConstants.resumeHistoryKey) ?? '[]';
      final List<dynamic> history = jsonDecode(historyJson);
      
      return history.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Share PDF file
  static Future<void> sharePDF(String filePath, String fileName) async {
    try {
      final file = XFile(filePath);
      await Share.shareXFiles(
        [file],
        text: 'Here is my resume: $fileName',
        subject: 'Resume - $fileName',
      );
    } catch (e) {
      throw Exception('Failed to share PDF: $e');
    }
  }

  /// View PDF file (opens with system default app)
  static Future<void> viewPDF(String filePath) async {
    try {
      final file = XFile(filePath);
      await Share.shareXFiles([file]);
    } catch (e) {
      throw Exception('Failed to open PDF: $e');
    }
  }

  /// Delete resume from history
  static Future<bool> deleteFromHistory(String resumeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(AppConstants.resumeHistoryKey) ?? '[]';
      final List<dynamic> history = jsonDecode(historyJson);
      
      final index = history.indexWhere((item) => item['id'] == resumeId);
      if (index != -1) {
        final item = history[index];
        
        // Delete local file if exists
        if (item['localPath'] != null) {
          final file = File(item['localPath']);
          if (await file.exists()) {
            await file.delete();
          }
        }
        
        history.removeAt(index);
        await prefs.setString(AppConstants.resumeHistoryKey, jsonEncode(history));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Upload photo for resume
  static Future<Map<String, dynamic>> uploadPhoto(File photoFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppConstants.resumeUploadPhotoUrl),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          photoFile.path,
        ),
      );

      final streamedResponse = await request.send()
          .timeout(Duration(seconds: AppConstants.receiveTimeout));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'photoUrl': responseData['photo_url'],
          'message': 'Photo uploaded successfully',
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to upload photo: ${response.statusCode}',
          'message': 'Upload failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Upload error occurred. Please check your connection.',
      };
    }
  }

  /// Validate resume data before submission
  static Map<String, dynamic> validateResumeData(ResumeData resumeData) {
    List<String> errors = [];

    // Validate personal info
    if (resumeData.personalInfo.fullName.trim().isEmpty) {
      errors.add('Full name is required');
    }
    if (resumeData.personalInfo.email.trim().isEmpty) {
      errors.add('Email is required');
    }
    if (resumeData.personalInfo.phone.trim().isEmpty) {
      errors.add('Phone number is required');
    }

    // Validate professional summary
    if (resumeData.professionalSummary.trim().isEmpty) {
      errors.add('Professional summary is required');
    }

    // Validate work experience
    bool hasValidExperience = resumeData.workExperiences.any((exp) =>
        exp.jobTitle.trim().isNotEmpty &&
        exp.companyName.trim().isNotEmpty);
    
    if (!hasValidExperience) {
      errors.add('At least one work experience is required');
    }

    // Validate education
    bool hasValidEducation = resumeData.educations.any((edu) =>
        edu.degree.trim().isNotEmpty &&
        edu.institution.trim().isNotEmpty);
    
    if (!hasValidEducation) {
      errors.add('At least one education entry is required');
    }

    return {
      'isValid': errors.isEmpty,
      'errors': errors,
    };
  }

  /// Save resume data locally (for draft functionality)
  static Future<bool> saveResumeLocally(ResumeData resumeData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.resumeDraftKey, jsonEncode(resumeData.toJson()));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Load resume data from local storage
  static Future<ResumeData?> loadResumeLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString(AppConstants.resumeDraftKey);
      if (draftJson != null) {
        final Map<String, dynamic> data = jsonDecode(draftJson);
        return ResumeData.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Clear draft
  static Future<void> clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.resumeDraftKey);
    } catch (e) {
      print('Error clearing draft: $e');
    }
  }

  /// Test connection to backend server
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/api/health/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Connected to server successfully',
          'serverUrl': AppConstants.baseUrl,
        };
      } else {
        return {
          'success': false,
          'message': 'Server responded with status: ${response.statusCode}',
          'serverUrl': AppConstants.baseUrl,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Cannot connect to server. Please check IP address and network.',
        'error': e.toString(),
        'serverUrl': AppConstants.baseUrl,
      };
    }
  }
}
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import '../utils/constants.dart';

class ConverterService {
  // Supported conversion mappings
  static const Map<String, List<String>> conversionMap = {
    'image': [
      'PDF',
      'DOCX',
      'PNG',
      'JPG',
      'JPEG',
      'WEBP',
      'BMP',
      'TIFF',
      'GIF'
    ],
    'pdf': ['DOCX', 'TXT', 'PNG', 'JPG', 'WEBP', 'PPTX'],
    'doc': ['PDF', 'TXT', 'PPTX'],
    'docx': ['PDF', 'TXT', 'PPTX'],
    'pptx': ['PDF', 'PNG', 'JPG', 'DOCX', 'TXT'],
    'txt': ['DOCX', 'PDF', 'PPTX'],
    'csv': ['TXT', 'PDF', 'DOCX', 'JSON', 'XLSX'],
    'xls': ['TXT', 'PDF', 'DOCX', 'JSON', 'CSV', 'XLSX'],
    'xlsx': ['TXT', 'PDF', 'DOCX', 'JSON', 'CSV'],
    'json': ['TXT', 'CSV', 'XLS', 'XLSX', 'PDF', 'DOCX'],
  };

  // Get file category from extension
  static String _getFileCategory(String extension) {
    final ext = extension.toLowerCase().replaceAll('.', '');

    if (['png', 'jpg', 'jpeg', 'webp', 'bmp', 'tiff', 'gif'].contains(ext)) {
      return 'image';
    } else if (ext == 'pdf') {
      return 'pdf';
    } else if (['doc', 'docx'].contains(ext)) {
      return ext;
    } else if (ext == 'pptx') {
      return 'pptx';
    } else if (ext == 'txt') {
      return 'txt';
    } else if (['csv', 'xls', 'xlsx'].contains(ext)) {
      return ext;
    } else if (ext == 'json') {
      return 'json';
    }
    return '';
  }

  // Get available target formats for a file
  static List<String> getAvailableFormats(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    final category = _getFileCategory(extension);
    return conversionMap[category] ?? [];
  }

  // Get endpoint URL based on file type
  static String _getEndpoint(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    final category = _getFileCategory(extension);

    switch (category) {
      case 'image':
        return AppConstants.convertImageUrl;
      case 'pdf':
        return AppConstants.convertPdfUrl;
      case 'doc':
      case 'docx':
        return AppConstants.convertDocUrl;
      case 'pptx':
        return AppConstants.convertPptxUrl;
      case 'txt':
        return AppConstants.convertTxtUrl;
      case 'csv':
      case 'xls':
      case 'xlsx':
        return AppConstants.convertCsvUrl;
      case 'json':
        return AppConstants.convertJsonUrl;
      default:
        throw Exception('Unsupported file type');
    }
  }

  // Get MIME type for file
  static String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();

    const mimeTypes = {
      'png': 'image/png',
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'webp': 'image/webp',
      'bmp': 'image/bmp',
      'tiff': 'image/tiff',
      'gif': 'image/gif',
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx':
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'pptx':
          'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'txt': 'text/plain',
      'csv': 'text/csv',
      'xls': 'application/vnd.ms-excel',
      'xlsx':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'json': 'application/json',
    };

    return mimeTypes[extension] ?? 'application/octet-stream';
  }

  // Convert file
  static Future<Map<String, dynamic>> convertFile({
    required File file,
    required String targetType,
    Function(double)? onProgress,
  }) async {
    try {
      final endpoint = _getEndpoint(file.path);
      final uri = Uri.parse(endpoint);

      // Create multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add file
      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();

      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: file.path.split('/').last,
        contentType: MediaType.parse(_getMimeType(file.path)),
      );

      request.files.add(multipartFile);

      // Add target type
      request.fields['target_type'] = targetType;

      // Send request
      final streamedResponse = await request.send();

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Success - return file bytes
        final fileName = 'converted.${targetType.toLowerCase()}';

        return {
          'success': true,
          'fileName': fileName,
          'fileBytes': response.bodyBytes,
          'targetType': targetType,
        };
      } else {
        // Error
        try {
          final errorData = json.decode(response.body);
          return {
            'success': false,
            'error': errorData['error'] ?? 'Conversion failed',
          };
        } catch (e) {
          return {
            'success': false,
            'error': 'Conversion failed with status ${response.statusCode}',
          };
        }
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  // Check if file type is supported
  static bool isFileSupported(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    final category = _getFileCategory(extension);
    return category.isNotEmpty;
  }
}

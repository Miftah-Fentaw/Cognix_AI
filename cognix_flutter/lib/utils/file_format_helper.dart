import 'package:flutter/material.dart';
import 'file_manager.dart';

class FileFormatHelper {
  /// Get icon for file format
  static IconData getIconForFormat(String format) {
    switch (format.toUpperCase()) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'DOCX':
      case 'DOC':
        return Icons.description;
      case 'PPTX':
        return Icons.slideshow;
      case 'TXT':
        return Icons.text_snippet;
      case 'PNG':
      case 'JPG':
      case 'JPEG':
      case 'WEBP':
      case 'BMP':
      case 'TIFF':
      case 'GIF':
        return Icons.image;
      case 'CSV':
      case 'XLS':
      case 'XLSX':
        return Icons.table_chart;
      case 'JSON':
        return Icons.code;
      default:
        return Icons.insert_drive_file;
    }
  }

  /// Get color for file format
  static Color getColorForFormat(String format) {
    switch (format.toUpperCase()) {
      case 'PDF':
        return const Color(0xFFFF3B30);
      case 'DOCX':
      case 'DOC':
        return const Color(0xFF007AFF);
      case 'PPTX':
        return const Color(0xFFFF9500);
      case 'TXT':
        return const Color(0xFF8E8E93);
      case 'PNG':
      case 'JPG':
      case 'JPEG':
      case 'WEBP':
      case 'BMP':
      case 'TIFF':
      case 'GIF':
        return const Color(0xFF34C759);
      case 'CSV':
      case 'XLS':
      case 'XLSX':
        return const Color(0xFF5856D6);
      case 'JSON':
        return const Color(0xFFAF52DE);
      default:
        return const Color(0xFF8E8E93);
    }
  }

  /// Get formatted file size
  static String getFileSize(List<int> bytes) {
    return FileManager.getFileSize(bytes.length);
  }
}

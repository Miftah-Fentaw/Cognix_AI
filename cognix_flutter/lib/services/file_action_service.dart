import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import '../utils/file_manager.dart';

class FileActionService {
  /// Save converted file to Cognix folder
  static Future<Map<String, dynamic>> saveConvertedFile({
    required List<int> fileBytes,
    required String fileName,
  }) async {
    try {
      // Save file to Cognix folder
      final file = await FileManager.saveFile(
        bytes: fileBytes,
        fileName: fileName,
      );

      return {
        'success': true,
        'message': 'File saved to Cognix folder',
        'file': file,
      };
    } on Exception catch (e) {
      if (e.toString().contains('permission')) {
        return {
          'success': false,
          'message': 'Storage permission denied. Please enable it in settings.',
        };
      } else {
        return {
          'success': false,
          'message': 'Error saving file: ${e.toString()}',
        };
      }
    }
  }

  /// View converted file with appropriate app
  static Future<Map<String, dynamic>> viewConvertedFile({
    required List<int> fileBytes,
    required String fileName,
  }) async {
    try {
      // Save file temporarily to view it
      final file = await FileManager.saveFile(
        bytes: fileBytes,
        fileName: fileName,
      );

      // Open file
      final result = await OpenFile.open(file.path);

      if (result.type != ResultType.done) {
        return {
          'success': false,
          'message': 'Could not open file: ${result.message}',
        };
      }

      return {
        'success': true,
        'message': 'File opened successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error opening file: ${e.toString()}',
      };
    }
  }

  /// Share converted file
  static Future<Map<String, dynamic>> shareConvertedFile({
    required List<int> fileBytes,
    required String fileName,
  }) async {
    try {
      // Save file temporarily to share it
      final file = await FileManager.saveFile(
        bytes: fileBytes,
        fileName: fileName,
      );

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Converted File',
      );

      return {
        'success': true,
        'message': 'File shared successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error sharing file: ${e.toString()}',
      };
    }
  }
}

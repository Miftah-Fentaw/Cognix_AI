import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileManager {
  static const String appFolderName = 'Cognix';

  /// Get the Cognix folder path in Downloads or Documents
  static Future<Directory> getCognixFolder() async {
    Directory? baseDirectory;

    if (Platform.isAndroid) {
      // Try to get Downloads directory first
      baseDirectory = Directory('/storage/emulated/0/Download');

      if (!await baseDirectory.exists()) {
        // Fallback to external storage
        baseDirectory = await getExternalStorageDirectory();
      }
    } else if (Platform.isIOS) {
      // For iOS, use documents directory
      baseDirectory = await getApplicationDocumentsDirectory();
    } else {
      // For other platforms
      baseDirectory = await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
    }

    // Create Cognix folder
    final cognixFolder = Directory('${baseDirectory!.path}/$appFolderName');

    if (!await cognixFolder.exists()) {
      await cognixFolder.create(recursive: true);
    }

    return cognixFolder;
  }

  /// Request storage permissions
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), we need different permissions
      if (await Permission.photos.isGranted ||
          await Permission.videos.isGranted ||
          await Permission.audio.isGranted) {
        return true;
      }

      // Request storage permission for older Android versions
      final status = await Permission.storage.request();

      if (status.isGranted) {
        return true;
      }

      // For Android 13+, request media permissions
      if (Platform.isAndroid) {
        final mediaStatus = await [
          Permission.photos,
          Permission.videos,
          Permission.audio,
        ].request();

        return mediaStatus.values.any((status) => status.isGranted);
      }

      return false;
    }

    // iOS doesn't need explicit storage permission for app documents
    return true;
  }

  /// Save file to Cognix folder
  static Future<File> saveFile({
    required List<int> bytes,
    required String fileName,
  }) async {
    // Request permission first
    final hasPermission = await requestStoragePermission();

    if (!hasPermission) {
      throw Exception('Storage permission denied');
    }

    // Get Cognix folder
    final cognixFolder = await getCognixFolder();

    // Create file path
    final filePath = '${cognixFolder.path}/$fileName';
    final file = File(filePath);

    // Write file
    await file.writeAsBytes(bytes, flush: true);

    return file;
  }

  /// Get all files in Cognix folder
  static Future<List<FileSystemEntity>> getCognixFiles() async {
    final cognixFolder = await getCognixFolder();

    if (!await cognixFolder.exists()) {
      return [];
    }

    return cognixFolder.listSync();
  }

  /// Delete file from Cognix folder
  static Future<void> deleteFile(String filePath) async {
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Get file size in readable format
  static String getFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  /// Check if file exists
  static Future<bool> fileExists(String filePath) async {
    final file = File(filePath);
    return await file.exists();
  }
}

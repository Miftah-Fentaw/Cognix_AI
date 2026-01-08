import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/file_conversion.dart';
import '../services/converter_service.dart';
import '../services/history_service.dart';

class ConverterProvider with ChangeNotifier {
  File? _selectedFile;
  String? _selectedTargetType;
  List<String> _availableFormats = [];
  bool _isConverting = false;
  double _conversionProgress = 0.0;
  String? _errorMessage;
  FileConversion? _convertedFile;

  // Getters
  File? get selectedFile => _selectedFile;
  String? get selectedTargetType => _selectedTargetType;
  List<String> get availableFormats => _availableFormats;
  bool get isConverting => _isConverting;
  double get conversionProgress => _conversionProgress;
  String? get errorMessage => _errorMessage;
  FileConversion? get convertedFile => _convertedFile;
  bool get hasSelectedFile => _selectedFile != null;
  bool get canConvert => _selectedFile != null && _selectedTargetType != null;

  // Select file
  void selectFile(File file) {
    _selectedFile = file;
    _selectedTargetType = null;
    _errorMessage = null;
    _convertedFile = null;

    // Get available formats for this file
    if (ConverterService.isFileSupported(file.path)) {
      _availableFormats = ConverterService.getAvailableFormats(file.path);
    } else {
      _availableFormats = [];
      _errorMessage = 'Unsupported file type';
    }

    notifyListeners();
  }

  // Select target format
  void selectTargetType(String targetType) {
    _selectedTargetType = targetType;
    _errorMessage = null;
    notifyListeners();
  }

  // Clear selection
  void clearSelection() {
    _selectedFile = null;
    _selectedTargetType = null;
    _availableFormats = [];
    _errorMessage = null;
    _convertedFile = null;
    _conversionProgress = 0.0;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Convert file
  Future<bool> convertFile() async {
    if (!canConvert) {
      _errorMessage = 'Please select a file and target format';
      notifyListeners();
      return false;
    }

    _isConverting = true;
    _conversionProgress = 0.0;
    _errorMessage = null;
    _convertedFile = null;
    notifyListeners();

    try {
      final result = await ConverterService.convertFile(
        file: _selectedFile!,
        targetType: _selectedTargetType!,
        onProgress: (progress) {
          _conversionProgress = progress;
          notifyListeners();
        },
      );

      if (result['success'] == true) {
        _convertedFile = FileConversion(
          targetType: result['targetType'],
          fileName: result['fileName'],
          fileBytes: result['fileBytes'],
        );
        await HistoryService.saveConversion(_convertedFile!);
        _conversionProgress = 1.0;
        _isConverting = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['error'] ?? 'Conversion failed';
        _isConverting = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      _isConverting = false;
      notifyListeners();
      return false;
    }
  }

  // Get file name without extension
  String? getFileName() {
    if (_selectedFile == null) return null;
    final name = _selectedFile!.path.split('/').last;
    return name.split('.').first;
  }

  // Get file extension
  String? getFileExtension() {
    if (_selectedFile == null) return null;
    return _selectedFile!.path.split('.').last.toUpperCase();
  }

  // Get file size in readable format
  String? getFileSize() {
    if (_selectedFile == null) return null;
    final bytes = _selectedFile!.lengthSync();

    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
}

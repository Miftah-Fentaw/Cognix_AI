import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/translation_model.dart';
import '../models/file_conversion.dart';
import '../models/generated_file_model.dart';

class HistoryService {
  static const String _translationKey = 'history_translations';
  static const String _conversionKey = 'history_conversions';
  static const String _generatedFileKey = 'history_generated_files';

  // --- Translation History ---

  static Future<void> saveTranslation(Translation translation) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_translationKey) ?? [];

    // Add new translation to the beginning
    Map<String, dynamic> jsonMap = {
      'text': translation.text,
      'source_lang': translation.sourceLang,
      'target_lang': translation.targetLang,
      'translation': translation.translatedText,
      'timestamp': DateTime.now()
          .toIso8601String(), // Add timestamp for sorting if needed
    };

    history.insert(0, jsonEncode(jsonMap));

    // Optional: Limit history size (e.g., maintain last 50 items)
    if (history.length > 50) {
      history.removeLast();
    }

    await prefs.setStringList(_translationKey, history);
  }

  static Future<List<Translation>> getTranslationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_translationKey) ?? [];

    return history.map((item) {
      try {
        return Translation.fromJson(jsonDecode(item));
      } catch (e) {
        return Translation(
            text: 'Error',
            sourceLang: '',
            targetLang: '',
            translatedText: 'Error loading item');
      }
    }).toList();
  }

  static Future<void> clearTranslationHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_translationKey);
  }

  // --- Conversion History ---

  static Future<void> saveConversion(FileConversion conversion) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_conversionKey) ?? [];

    // We can't save file bytes to SP efficiently, checking if we should save just metadata
    // For now, let's save metadata and maybe the path provided it is persistent,
    // but the model has 'fileBytes'.
    // Re-saving byte arrays in SharedPrefs is bad practice (size limits).
    // Ideally we save the file to disk and store the path.
    // Assuming for this implementation we might want to skip saving bytes or save minimal info.

    // IMPORTANT: Storing large file bytes in SharedPreferences will crash the app.
    // We will store metadata only for history display. To open it, we'd need the file on disk.
    // For this implementation, we'll store metadata.

    Map<String, dynamic> jsonMap = {
      'targetType': conversion.targetType,
      'fileName': conversion.fileName,
      'timestamp': DateTime.now().toIso8601String(),
      // 'fileBytes': ... // SKIPPING BYTES for performance/stability
    };

    history.insert(0, jsonEncode(jsonMap));
    if (history.length > 50) history.removeLast();

    await prefs.setStringList(_conversionKey, history);
  }

  static Future<List<Map<String, dynamic>>> getConversionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_conversionKey) ?? [];

    return history
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }

  static Future<void> clearConversionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_conversionKey);
  }

  // --- File Generation History ---

  static Future<void> saveGeneratedFile(GeneratedFile file) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_generatedFileKey) ?? [];

    history.insert(0, jsonEncode(file.toJson()));
    if (history.length > 50) history.removeLast();

    await prefs.setStringList(_generatedFileKey, history);
  }

  static Future<List<GeneratedFile>> getGeneratedFileHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_generatedFileKey) ?? [];

    return history
        .map((item) => GeneratedFile.fromJson(jsonDecode(item)))
        .toList();
  }

  static Future<void> clearGeneratedFileHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_generatedFileKey);
  }
}

import 'package:flutter/material.dart';
import '../models/translation_model.dart';
import '../services/translation_service.dart';
import '../services/history_service.dart';

class TranslationProvider with ChangeNotifier {
  Translation? _translation;
  bool _loading = false;
  String? _error;

  Translation? get translation => _translation;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> translateText(
      String text, String sourceLang, String targetLang) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _translation =
          await TranslationService.translate(text, sourceLang, targetLang);
      if (_translation != null) {
        await HistoryService.saveTranslation(_translation!);
      }
    } catch (e) {
      _error = e.toString();
      _translation = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

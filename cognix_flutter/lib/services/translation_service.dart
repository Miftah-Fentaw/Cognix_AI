import 'dart:convert';
import 'package:cognix/utils/constants.dart';
import 'package:http/http.dart' as http;
import '../models/translation_model.dart';

class TranslationService {
  static Future<Translation> translate(String text, String sourceLang, String targetLang) async {
    final response = await http.post(
      Uri.parse(AppConstants.translateEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "text": text,
        "source_lang": sourceLang,
        "target_lang": targetLang
      }),
    );

    if (response.statusCode == 200) {
      return Translation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        "Failed to translate: ${jsonDecode(response.body)['error'] ?? 'Unknown error'}"
      );
    }
  }
}

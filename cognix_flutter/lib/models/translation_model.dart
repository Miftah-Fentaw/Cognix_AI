class Translation {
  final String text;
  final String sourceLang;
  final String targetLang;
  final String translatedText;

  Translation({
    required this.text,
    required this.sourceLang,
    required this.targetLang,
    required this.translatedText,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      text: json['text'] ?? '',
      sourceLang: json['source_lang'] ?? '',
      targetLang: json['target_lang'] ?? '',
      translatedText: json['translation'] ?? '',
    );
  }
}

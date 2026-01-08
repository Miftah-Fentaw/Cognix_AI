import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/translation_model.dart';

class TranslationCard extends StatelessWidget {
  final Translation translation;

  const TranslationCard({Key? key, required this.translation})
      : super(key: key);

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Translation copied to clipboard'),
        backgroundColor: const Color(0xFF34C759),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              translation.translatedText,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1C1C1E),
                height: 1.5,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E5EA)),
          InkWell(
            onTap: () => _copyToClipboard(context, translation.translatedText),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.copy,
                    size: 18,
                    color: Color(0xFF007AFF),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Copy Translation',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

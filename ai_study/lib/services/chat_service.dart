class ChatService {
  Future<String> processText(String input) async {
    // TODO: Replace with HTTP POST to Django
    await Future.delayed(const Duration(seconds: 2));

    return '''
📘 Summary:
This is a generated academic summary.

📝 Notes:
• Key idea one
• Key idea two

❓ Q&A:
Q: What is the topic?
A: The topic is...
''';
  }
}

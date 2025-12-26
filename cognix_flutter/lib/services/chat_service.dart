import 'dart:convert';
import 'package:cognix/model/AIResponse.dart';
import 'package:http/http.dart' as http;


// text based input manager to talk to AI server(grokk)
class AIService {
  static Future<AIResponse> fetchAIResponse(String text) async {
    final url = Uri.parse("http://192.168.0.132:8000/api/process-text/");
    print('ChatService POST $url body=${jsonEncode({'text': text})}');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": text}),
    );
    print('ChatService response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      return AIResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch AI response: ${response.statusCode}');
    }
  }
}

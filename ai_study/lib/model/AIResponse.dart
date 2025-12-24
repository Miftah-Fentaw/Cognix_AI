class AIResponse {
  final String summary;
  final List<String> shortNotes;
  final List<String> questions;
  final List<String> answers;

  AIResponse({
    required this.summary,
    required this.shortNotes,
    required this.questions,
    required this.answers,
  });

  factory AIResponse.fromJson(Map<String, dynamic> json) => AIResponse(
        summary: json['summary'],
        shortNotes: List<String>.from(json['short_notes']),
        questions: List<String>.from(json['questions']),
        answers: List<String>.from(json['answers']),
      );
}

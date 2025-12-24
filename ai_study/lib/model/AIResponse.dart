class QuizQuestion {
  final String question;
  final List<String> options;
  final String answer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
        question: json['question'] ?? 'Unknown Question',
        options: List<String>.from(json['options'] ?? []),
        answer: json['answer'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'question': question,
        'options': options,
        'answer': answer,
      };
}

class AIResponse {
  final String summary;
  final List<String> shortNotes;
  final List<QuizQuestion> quiz;

  AIResponse({
    required this.summary,
    required this.shortNotes,
    required this.quiz,
  });

  factory AIResponse.fromJson(Map<String, dynamic> json) => AIResponse(
        summary: json['summary'],
        shortNotes: List<String>.from(json['short_notes'] ?? []),
        quiz: (json['quiz'] as List?)
                ?.map((e) => QuizQuestion.fromJson(e))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'summary': summary,
        'short_notes': shortNotes,
        'quiz': quiz.map((q) => q.toJson()).toList(),
      };
}

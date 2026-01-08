class GeneratedFile {
  final String id;
  final String title;
  final String content;
  final String type; // 'summary', 'note', etc.
  final DateTime createdAt;

  GeneratedFile({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory GeneratedFile.fromJson(Map<String, dynamic> json) {
    return GeneratedFile(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

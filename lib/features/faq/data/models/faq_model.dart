class FaqModel {
  final String id;
  final String title;
  final String answer;
  final DateTime createdAt;

  FaqModel({
    required this.id,
    required this.title,
    required this.answer,
    required this.createdAt,
  });

  FaqModel copyWith({
    String? id,
    String? title,
    String? answer,
    DateTime? createdAt,
  }) {
    return FaqModel(
      id: id ?? this.id,
      title: title ?? this.title,
      answer: answer ?? this.answer,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'answer': answer,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      answer: json['description'] ?? json['answer'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

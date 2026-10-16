class AnnouncementModel {
  final String id;
  final String title;
  final String audience;
  final String? category;
  final String? actionText;
  final String? actionUrl;
  final String description;
  final DateTime createdAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.audience,
    this.category,
    this.actionText,
    this.actionUrl,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'audience': audience,
      'category': category,
      'actionText': actionText,
      'actionUrl': actionUrl,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      audience: json['audience'] ?? 'User',
      category: json['category'],
      actionText: json['actionText'],
      actionUrl: json['actionUrl'],
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

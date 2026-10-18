class AnnouncementModel {
  final String id;
  final String title;
  final String audience;
  final String? category;
  final String? actionText;
  final String? actionUrl;
  final String description;
  final String? status;
  final DateTime? scheduledAt;
  final DateTime? expiresAt;
  final DateTime createdAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.audience,
    this.category,
    this.actionText,
    this.actionUrl,
    required this.description,
    this.status,
    this.scheduledAt,
    this.expiresAt,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'audience': audience,
      if (category != null) 'category': category,
      if (actionText != null) 'actionText': actionText,
      if (actionUrl != null) 'actionURL': actionUrl,
      'description': description,
      if (status != null) 'status': status,
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toIso8601String(),
      if (expiresAt != null) 'expiresAt': expiresAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic d) {
      if (d == null) return null;
      try {
        return DateTime.parse(d.toString());
      } catch (_) {
        return null;
      }
    }

    return AnnouncementModel(
      id: json['id']?.toString() ?? json['announcementId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      audience: json['audience']?.toString() ?? 'User',
      category: json['category']?.toString(),
      actionText: json['actionText']?.toString(),
      actionUrl: (json['actionUrl'] ?? json['actionURL'])?.toString(),
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString(),
      scheduledAt: parseDate(json['scheduledAt']),
      expiresAt: parseDate(json['expiresAt']),
      createdAt: parseDate(json['createdAt']) ?? DateTime.now(),
    );
  }
}

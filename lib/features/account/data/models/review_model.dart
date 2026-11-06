class ReviewModel {
  final dynamic id;
  final String targetType;
  final int targetId;
  final double rating;
  final String reviewText;
  final dynamic comment;
  final Map<String, dynamic>? metadata;
  final String? reviewerName;
  final String? reviewerAvatar;
  final DateTime? createdAt;

  const ReviewModel({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.rating,
    required this.reviewText,
    this.comment,
    this.metadata,
    this.reviewerName,
    this.reviewerAvatar,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    // Reviewer details can come from creator/user/userAccount nested object or top-level
    final userObj = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : (json['createdBy'] is Map<String, dynamic>
            ? json['createdBy'] as Map<String, dynamic>
            : null);

    final reviewerName = userObj?['name']?.toString() ??
        json['reviewerName']?.toString() ??
        json['name']?.toString() ??
        'Verified Customer';

    final reviewerAvatar = userObj?['avatarUrl']?.toString() ??
        userObj?['avatar']?.toString() ??
        json['reviewerAvatar']?.toString() ??
        json['avatarUrl']?.toString();

    // Text can be in reviewText or comment object/string
    String reviewText = json['reviewText']?.toString() ?? '';
    if (reviewText.isEmpty && json['comment'] != null) {
      if (json['comment'] is String) {
        reviewText = json['comment'];
      } else if (json['comment'] is Map) {
        reviewText = json['comment']['text']?.toString() ??
            json['comment']['remark']?.toString() ??
            json['comment']['comment']?.toString() ??
            '';
      }
    }

    DateTime? createdAt;
    if (json['createdAt'] != null) {
      createdAt = DateTime.tryParse(json['createdAt'].toString());
    }

    final rawRating = json['rating'] ?? json['stars'] ?? 5;
    final rating = (rawRating is num) ? rawRating.toDouble() : 5.0;

    return ReviewModel(
      id: json['id'] ?? 0,
      targetType: json['targetType']?.toString().toUpperCase() ?? 'SERVICE',
      targetId: (json['targetId'] as num?)?.toInt() ?? 0,
      rating: rating,
      reviewText: reviewText,
      comment: json['comment'],
      metadata: json['metadata'] is Map<String, dynamic> ? json['metadata'] : null,
      reviewerName: reviewerName,
      reviewerAvatar: reviewerAvatar,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetType': targetType,
      'targetId': targetId,
      'rating': rating,
      'reviewText': reviewText,
      'comment': comment ?? {'text': reviewText},
      'metadata': metadata ?? {},
    };
  }
}

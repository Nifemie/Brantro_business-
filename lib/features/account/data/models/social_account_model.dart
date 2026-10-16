class SocialAccountModel {
  final int id;
  final int userId;
  final String platform;
  final String handle;
  final String profileUrl;
  final int followers;
  final bool isPrimary;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SocialAccountModel({
    required this.id,
    required this.userId,
    required this.platform,
    required this.handle,
    required this.profileUrl,
    required this.followers,
    required this.isPrimary,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory SocialAccountModel.fromJson(Map<String, dynamic> json) {
    return SocialAccountModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      userId: int.tryParse(json['userId']?.toString() ?? '') ?? 0,
      platform: json['platform'] ?? '',
      handle: json['handle'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
      followers: int.tryParse(json['followers']?.toString() ?? '') ?? 0,
      isPrimary: json['isPrimary'] == true,
      isActive: json['isActive'] == true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'platform': platform,
      'handle': handle,
      'profileUrl': profileUrl,
      'followers': followers,
      'isPrimary': isPrimary,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

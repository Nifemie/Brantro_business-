class UserAnalyticsModel {
  final int followers;
  final int impressions;
  final int reach;
  final int profileViews;
  final int likes;
  final int completedOrders;
  final double totalRevenue;
  final int totalReviews;

  const UserAnalyticsModel({
    this.followers = 0,
    this.impressions = 0,
    this.reach = 0,
    this.profileViews = 0,
    this.likes = 0,
    this.completedOrders = 0,
    this.totalRevenue = 0.0,
    this.totalReviews = 0,
  });

  factory UserAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return UserAnalyticsModel(
      followers: (json['followers'] as num?)?.toInt() ?? (json['totalFollowers'] as num?)?.toInt() ?? 0,
      impressions: (json['impressions'] as num?)?.toInt() ?? (json['totalImpressions'] as num?)?.toInt() ?? 0,
      reach: (json['reach'] as num?)?.toInt() ?? (json['totalReach'] as num?)?.toInt() ?? 0,
      profileViews: (json['profileViews'] as num?)?.toInt() ?? (json['totalViews'] as num?)?.toInt() ?? 0,
      likes: (json['likes'] as num?)?.toInt() ?? (json['totalLikes'] as num?)?.toInt() ?? 0,
      completedOrders: (json['completedOrders'] as num?)?.toInt() ?? (json['ordersCompleted'] as num?)?.toInt() ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? (json['revenue'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? (json['reviewsCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'followers': followers,
      'impressions': impressions,
      'reach': reach,
      'profileViews': profileViews,
      'likes': likes,
      'completedOrders': completedOrders,
      'totalRevenue': totalRevenue,
      'totalReviews': totalReviews,
    };
  }

  UserAnalyticsModel copyWith({
    int? followers,
    int? impressions,
    int? reach,
    int? profileViews,
    int? likes,
    int? completedOrders,
    double? totalRevenue,
    int? totalReviews,
  }) {
    return UserAnalyticsModel(
      followers: followers ?? this.followers,
      impressions: impressions ?? this.impressions,
      reach: reach ?? this.reach,
      profileViews: profileViews ?? this.profileViews,
      likes: likes ?? this.likes,
      completedOrders: completedOrders ?? this.completedOrders,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}

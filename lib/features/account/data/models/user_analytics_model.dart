class UserAnalyticsModel {
  final int followers;
  final int impressions;
  final int reach;
  final int profileViews;

  const UserAnalyticsModel({
    this.followers = 0,
    this.impressions = 0,
    this.reach = 0,
    this.profileViews = 0,
  });

  factory UserAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return UserAnalyticsModel(
      followers: (json['followers'] as num?)?.toInt() ?? 0,
      impressions: (json['impressions'] as num?)?.toInt() ?? 0,
      reach: (json['reach'] as num?)?.toInt() ?? 0,
      profileViews: (json['profileViews'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'followers': followers,
      'impressions': impressions,
      'reach': reach,
      'profileViews': profileViews,
    };
  }

  UserAnalyticsModel copyWith({
    int? followers,
    int? impressions,
    int? reach,
    int? profileViews,
  }) {
    return UserAnalyticsModel(
      followers: followers ?? this.followers,
      impressions: impressions ?? this.impressions,
      reach: reach ?? this.reach,
      profileViews: profileViews ?? this.profileViews,
    );
  }
}

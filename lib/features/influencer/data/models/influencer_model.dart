class InfluencerModel {
  final int id;
  final String name;
  final String? avatarUrl;
  final double? averageRating;
  final int? totalLikes;
  final InfluencerAdditionalInfo? additionalInfo;
  final String? country;
  final String? state;
  final String? city;
  final bool isVerified;
  final String status;

  InfluencerModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.averageRating,
    this.totalLikes,
    this.additionalInfo,
    this.country,
    this.state,
    this.city,
    required this.isVerified,
    required this.status,
  });

  factory InfluencerModel.fromJson(Map<String, dynamic> json) {
    return InfluencerModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      avatarUrl: json['avatarUrl'],
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalLikes: json['totalLikes'] ?? 0,
      additionalInfo: json['additionalInfo'] != null
          ? InfluencerAdditionalInfo.fromJson(json['additionalInfo'])
          : null,
      country: json['country'],
      state: json['state'],
      city: json['city'],
      isVerified: json['isVerified'] ?? false,
      status: json['status'] ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'averageRating': averageRating,
      'totalLikes': totalLikes,
      'additionalInfo': additionalInfo?.toJson(),
      'country': country,
      'state': state,
      'city': city,
      'isVerified': isVerified,
      'status': status,
    };
  }
}

class InfluencerAdditionalInfo {
  final String? niche;
  final String? displayName;
  final String? portfolioLink;
  final List<String>? contentFormats;
  final String? contentCategory;
  final String? primaryPlatform;
  final String? availabilityType;
  final String? audienceSizeRange;

  InfluencerAdditionalInfo({
    this.niche,
    this.displayName,
    this.portfolioLink,
    this.contentFormats,
    this.contentCategory,
    this.primaryPlatform,
    this.availabilityType,
    this.audienceSizeRange,
  });

  factory InfluencerAdditionalInfo.fromJson(Map<String, dynamic> json) {
    return InfluencerAdditionalInfo(
      niche: json['niche'],
      displayName: json['displayName'],
      portfolioLink: json['portfolioLink'],
      contentFormats: json['contentFormats'] != null
          ? List<String>.from(json['contentFormats'])
          : [],
      contentCategory: json['contentCategory'],
      primaryPlatform: json['primaryPlatform'],
      availabilityType: json['availabilityType'],
      audienceSizeRange: json['audienceSizeRange'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'niche': niche,
      'displayName': displayName,
      'portfolioLink': portfolioLink,
      'contentFormats': contentFormats,
      'contentCategory': contentCategory,
      'primaryPlatform': primaryPlatform,
      'availabilityType': availabilityType,
      'audienceSizeRange': audienceSizeRange,
    };
  }
}

class UgcCreatorModel {
  final int id;
  final String name;
  final String? phoneNumber;
  final String? emailAddress;
  final String? avatarUrl;
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final double averageRating;
  final int totalLikes;
  final UgcCreatorAdditionalInfo? additionalInfo;

  UgcCreatorModel({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.emailAddress,
    this.avatarUrl,
    this.country,
    this.state,
    this.city,
    this.address,
    required this.averageRating,
    required this.totalLikes,
    this.additionalInfo,
  });

  factory UgcCreatorModel.fromJson(Map<String, dynamic> json) {
    return UgcCreatorModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      emailAddress: json['emailAddress'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalLikes: json['totalLikes'] as int? ?? 0,
      additionalInfo: json['additionalInfo'] != null
          ? UgcCreatorAdditionalInfo.fromJson(
              json['additionalInfo'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'avatarUrl': avatarUrl,
      'country': country,
      'state': state,
      'city': city,
      'address': address,
      'averageRating': averageRating,
      'totalLikes': totalLikes,
      'additionalInfo': additionalInfo?.toJson(),
    };
  }
}

class UgcCreatorAdditionalInfo {
  final List<String>? niches;
  final String? displayName;
  final List<String>? contentStyle;
  final String? portfolioLink;
  final List<String>? contentFormats;
  final String? availabilityType;
  final int? yearsOfExperience;

  UgcCreatorAdditionalInfo({
    this.niches,
    this.displayName,
    this.contentStyle,
    this.portfolioLink,
    this.contentFormats,
    this.availabilityType,
    this.yearsOfExperience,
  });

  factory UgcCreatorAdditionalInfo.fromJson(Map<String, dynamic> json) {
    return UgcCreatorAdditionalInfo(
      niches: json['niches'] != null
          ? List<String>.from(json['niches'] as List)
          : null,
      displayName: json['displayName'] as String?,
      contentStyle: json['contentStyle'] != null
          ? List<String>.from(json['contentStyle'] as List)
          : null,
      portfolioLink: json['portfolioLink'] as String?,
      contentFormats: json['contentFormats'] != null
          ? List<String>.from(json['contentFormats'] as List)
          : null,
      availabilityType: json['availabilityType'] as String?,
      yearsOfExperience: json['yearsOfExperience'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'niches': niches,
      'displayName': displayName,
      'contentStyle': contentStyle,
      'portfolioLink': portfolioLink,
      'contentFormats': contentFormats,
      'availabilityType': availabilityType,
      'yearsOfExperience': yearsOfExperience,
    };
  }
}

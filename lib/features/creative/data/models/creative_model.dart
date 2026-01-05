class CreativeModel {
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
  final CreativeAdditionalInfo? additionalInfo;

  CreativeModel({
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

  factory CreativeModel.fromJson(Map<String, dynamic> json) {
    return CreativeModel(
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
          ? CreativeAdditionalInfo.fromJson(
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

class CreativeAdditionalInfo {
  final List<String>? skills;
  final List<String>? toolsUsed;
  final String? displayName;
  final String? creativeType;
  final String? portfolioLink;
  final String? specialization;
  final String? availabilityType;
  final int? numberOfProjects;
  final int? yearsOfExperience;

  CreativeAdditionalInfo({
    this.skills,
    this.toolsUsed,
    this.displayName,
    this.creativeType,
    this.portfolioLink,
    this.specialization,
    this.availabilityType,
    this.numberOfProjects,
    this.yearsOfExperience,
  });

  factory CreativeAdditionalInfo.fromJson(Map<String, dynamic> json) {
    return CreativeAdditionalInfo(
      skills: json['skills'] != null
          ? List<String>.from(json['skills'] as List)
          : null,
      toolsUsed: json['toolsUsed'] != null
          ? List<String>.from(json['toolsUsed'] as List)
          : null,
      displayName: json['displayName'] as String?,
      creativeType: json['creativeType'] as String?,
      portfolioLink: json['portfolioLink'] as String?,
      specialization: json['specialization'] as String?,
      availabilityType: json['availabilityType'] as String?,
      numberOfProjects: json['numberOfProjects'] as int?,
      yearsOfExperience: json['yearsOfExperience'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skills': skills,
      'toolsUsed': toolsUsed,
      'displayName': displayName,
      'creativeType': creativeType,
      'portfolioLink': portfolioLink,
      'specialization': specialization,
      'availabilityType': availabilityType,
      'numberOfProjects': numberOfProjects,
      'yearsOfExperience': yearsOfExperience,
    };
  }
}

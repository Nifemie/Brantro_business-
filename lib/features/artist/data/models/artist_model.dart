class ArtistModel {
  final int id;
  final String name;
  final String? avatarUrl;
  final double? averageRating;
  final int? totalLikes;
  final ArtistAdditionalInfo? additionalInfo;
  final String? country;
  final String? state;
  final String? city;
  final bool isVerified;
  final String status;

  ArtistModel({
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

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      avatarUrl: json['avatarUrl'],
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalLikes: json['totalLikes'] ?? 0,
      additionalInfo: json['additionalInfo'] != null
          ? ArtistAdditionalInfo.fromJson(json['additionalInfo'])
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

class ArtistAdditionalInfo {
  final List<String>? genres;
  final String? stageName;
  final String? specialization;
  final int? yearsOfExperience;
  final int? numberOfProductions;
  final String? primaryProfession;
  final String? portfolioLink;
  final String? managementType;

  ArtistAdditionalInfo({
    this.genres,
    this.stageName,
    this.specialization,
    this.yearsOfExperience,
    this.numberOfProductions,
    this.primaryProfession,
    this.portfolioLink,
    this.managementType,
  });

  factory ArtistAdditionalInfo.fromJson(Map<String, dynamic> json) {
    return ArtistAdditionalInfo(
      genres: List<String>.from(json['genres'] ?? []),
      stageName: json['stageName'],
      specialization: json['specialization'],
      yearsOfExperience: json['yearsOfExperience'],
      numberOfProductions: json['numberOfProductions'],
      primaryProfession: json['primaryProfession'],
      portfolioLink: json['portfolioLink'],
      managementType: json['managementType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'genres': genres,
      'stageName': stageName,
      'specialization': specialization,
      'yearsOfExperience': yearsOfExperience,
      'numberOfProductions': numberOfProductions,
      'primaryProfession': primaryProfession,
      'portfolioLink': portfolioLink,
      'managementType': managementType,
    };
  }
}

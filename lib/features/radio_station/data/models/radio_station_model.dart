class RadioStationModel {
  final int id;
  final String name;
  final String? avatarUrl;
  final double averageRating;
  final int totalLikes;
  final String country;
  final String state;
  final String city;
  final bool isVerified;
  final String status;
  final RadioStationAdditionalInfo additionalInfo;

  RadioStationModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.averageRating,
    required this.totalLikes,
    required this.country,
    required this.state,
    required this.city,
    required this.isVerified,
    required this.status,
    required this.additionalInfo,
  });

  factory RadioStationModel.fromJson(Map<String, dynamic> json) {
    return RadioStationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      averageRating: (json['averageRating'] as num).toDouble(),
      totalLikes: json['totalLikes'] as int,
      country: json['country'] as String,
      state: json['state'] as String,
      city: json['city'] as String,
      isVerified: json['isVerified'] as bool,
      status: json['status'] as String,
      additionalInfo: RadioStationAdditionalInfo.fromJson(
        json['additionalInfo'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatarUrl': avatarUrl,
    'averageRating': averageRating,
    'totalLikes': totalLikes,
    'country': country,
    'state': state,
    'city': city,
    'isVerified': isVerified,
    'status': status,
    'additionalInfo': additionalInfo.toJson(),
  };
}

class RadioStationAdditionalInfo {
  final String? rcNumber;
  final String? tinNumber;
  final String? businessName;
  final String? contactPhone;
  final List<String>? contentFocus;
  final String? broadcastBand;
  final String? businessAddress;
  final String? businessWebsite;
  final String? primaryLanguage;
  final List<String>? operatingRegions;
  final int? yearsOfOperation;
  final int? averageDailyListenership;

  RadioStationAdditionalInfo({
    this.rcNumber,
    this.tinNumber,
    this.businessName,
    this.contactPhone,
    this.contentFocus,
    this.broadcastBand,
    this.businessAddress,
    this.businessWebsite,
    this.primaryLanguage,
    this.operatingRegions,
    this.yearsOfOperation,
    this.averageDailyListenership,
  });

  factory RadioStationAdditionalInfo.fromJson(Map<String, dynamic> json) {
    return RadioStationAdditionalInfo(
      rcNumber: json['rcNumber'] as String?,
      tinNumber: json['tinNumber'] as String?,
      businessName: json['businessName'] as String?,
      contactPhone: json['contactPhone'] as String?,
      contentFocus: json['contentFocus'] != null
          ? List<String>.from(json['contentFocus'] as List)
          : null,
      broadcastBand: json['broadcastBand'] as String?,
      businessAddress: json['businessAddress'] as String?,
      businessWebsite: json['businessWebsite'] as String?,
      primaryLanguage: json['primaryLanguage'] as String?,
      operatingRegions: json['operatingRegions'] != null
          ? List<String>.from(json['operatingRegions'] as List)
          : null,
      yearsOfOperation: json['yearsOfOperation'] as int?,
      averageDailyListenership: json['averageDailyListenership'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'rcNumber': rcNumber,
    'tinNumber': tinNumber,
    'businessName': businessName,
    'contactPhone': contactPhone,
    'contentFocus': contentFocus,
    'broadcastBand': broadcastBand,
    'businessAddress': businessAddress,
    'businessWebsite': businessWebsite,
    'primaryLanguage': primaryLanguage,
    'operatingRegions': operatingRegions,
    'yearsOfOperation': yearsOfOperation,
    'averageDailyListenership': averageDailyListenership,
  };
}

class TvStationModel {
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
  final TvStationAdditionalInfo additionalInfo;

  TvStationModel({
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

  factory TvStationModel.fromJson(Map<String, dynamic> json) {
    return TvStationModel(
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
      additionalInfo: TvStationAdditionalInfo.fromJson(
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

class TvStationAdditionalInfo {
  final String? rcNumber;
  final String? tinNumber;
  final String? channelType;
  final String? businessName;
  final String? contactPhone;
  final List<String>? contentFocus;
  final String? broadcastType;
  final String? businessAddress;
  final String? businessWebsite;
  final List<String>? operatingRegions;
  final int? yearsOfOperation;
  final int? averageDailyViewership;

  TvStationAdditionalInfo({
    this.rcNumber,
    this.tinNumber,
    this.channelType,
    this.businessName,
    this.contactPhone,
    this.contentFocus,
    this.broadcastType,
    this.businessAddress,
    this.businessWebsite,
    this.operatingRegions,
    this.yearsOfOperation,
    this.averageDailyViewership,
  });

  factory TvStationAdditionalInfo.fromJson(Map<String, dynamic> json) {
    return TvStationAdditionalInfo(
      rcNumber: json['rcNumber'] as String?,
      tinNumber: json['tinNumber'] as String?,
      channelType: json['channelType'] as String?,
      businessName: json['businessName'] as String?,
      contactPhone: json['contactPhone'] as String?,
      contentFocus: json['contentFocus'] != null
          ? List<String>.from(json['contentFocus'] as List)
          : null,
      broadcastType: json['broadcastType'] as String?,
      businessAddress: json['businessAddress'] as String?,
      businessWebsite: json['businessWebsite'] as String?,
      operatingRegions: json['operatingRegions'] != null
          ? List<String>.from(json['operatingRegions'] as List)
          : null,
      yearsOfOperation: json['yearsOfOperation'] as int?,
      averageDailyViewership: json['averageDailyViewership'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'rcNumber': rcNumber,
    'tinNumber': tinNumber,
    'channelType': channelType,
    'businessName': businessName,
    'contactPhone': contactPhone,
    'contentFocus': contentFocus,
    'broadcastType': broadcastType,
    'businessAddress': businessAddress,
    'businessWebsite': businessWebsite,
    'operatingRegions': operatingRegions,
    'yearsOfOperation': yearsOfOperation,
    'averageDailyViewership': averageDailyViewership,
  };
}

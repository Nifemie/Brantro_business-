class ArtistInfo {
  final String stageName;
  final String primaryProfession;
  final String specialization;
  final List<String> genres;
  final int yearsOfExperience;
  final int numberOfProductions;
  final String availabilityType;
  final String? portfolioLink;
  final String managementType;

  ArtistInfo({
    required this.stageName,
    required this.primaryProfession,
    required this.specialization,
    required this.genres,
    required this.yearsOfExperience,
    required this.numberOfProductions,
    required this.availabilityType,
    this.portfolioLink,
    required this.managementType,
  });

  Map<String, dynamic> toJson() {
    return {
      'stageName': stageName,
      'primaryProfession': primaryProfession,
      'specialization': specialization,
      'genres': genres,
      'yearsOfExperience': yearsOfExperience,
      'numberOfProductions': numberOfProductions,
      'availabilityType': availabilityType,
      if (portfolioLink != null) 'portfolioLink': portfolioLink,
      'managementType': managementType,
    };
  }

  factory ArtistInfo.fromJson(Map<String, dynamic> json) {
    return ArtistInfo(
      stageName: json['stageName'],
      primaryProfession: json['primaryProfession'],
      specialization: json['specialization'],
      genres: List<String>.from(json['genres']),
      yearsOfExperience: json['yearsOfExperience'],
      numberOfProductions: json['numberOfProductions'],
      availabilityType: json['availabilityType'],
      portfolioLink: json['portfolioLink'],
      managementType: json['managementType'],
    );
  }
}

class AdvertiserInfo {
  final String? businessName;
  final String? businessAddress;
  final String? industry;
  final String? telephoneNumber;
  final String? businessWebsite;
  final String? idType;
  final String? idNumber;
  final String? tinNumber;

  AdvertiserInfo({
    this.businessName,
    this.businessAddress,
    this.industry,
    this.telephoneNumber,
    this.businessWebsite,
    this.idType,
    this.idNumber,
    this.tinNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      if (businessName != null) 'businessName': businessName,
      if (businessAddress != null) 'businessAddress': businessAddress,
      if (industry != null) 'industry': industry,
      if (telephoneNumber != null) 'telephoneNumber': telephoneNumber,
      if (businessWebsite != null) 'businessWebsite': businessWebsite,
      if (idType != null) 'idType': idType,
      if (idNumber != null) 'idNumber': idNumber,
      if (tinNumber != null) 'tinNumber': tinNumber,
    };
  }

  factory AdvertiserInfo.fromJson(Map<String, dynamic> json) {
    return AdvertiserInfo(
      businessName: json['businessName'],
      businessAddress: json['businessAddress'],
      industry: json['industry'],
      telephoneNumber: json['telephoneNumber'],
      businessWebsite: json['businessWebsite'],
      idType: json['idType'],
      idNumber: json['idNumber'],
      tinNumber: json['tinNumber'],
    );
  }
}

class ScreenBillboardInfo {
  final String businessName;
  final String permitNumber;
  final String industry;
  final List<String> operatingStates;
  final String? yearsOfOperation;
  final String? businessWebsite;
  final String businessAddress;
  final String idType;
  final String idRcNumber;
  final String tinNumber;

  ScreenBillboardInfo({
    required this.businessName,
    required this.permitNumber,
    required this.industry,
    required this.operatingStates,
    this.yearsOfOperation,
    this.businessWebsite,
    required this.businessAddress,
    required this.idType,
    required this.idRcNumber,
    required this.tinNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'permitNumber': permitNumber,
      'industry': industry,
      'operatingStates': operatingStates,
      if (yearsOfOperation != null) 'yearsOfOperation': yearsOfOperation,
      if (businessWebsite != null) 'businessWebsite': businessWebsite,
      'businessAddress': businessAddress,
      'idType': idType,
      'idRcNumber': idRcNumber,
      'tinNumber': tinNumber,
    };
  }

  factory ScreenBillboardInfo.fromJson(Map<String, dynamic> json) {
    return ScreenBillboardInfo(
      businessName: json['businessName'],
      permitNumber: json['permitNumber'],
      industry: json['industry'],
      operatingStates: List<String>.from(json['operatingStates']),
      yearsOfOperation: json['yearsOfOperation'],
      businessWebsite: json['businessWebsite'],
      businessAddress: json['businessAddress'],
      idType: json['idType'],
      idRcNumber: json['idRcNumber'],
      tinNumber: json['tinNumber'],
    );
  }
}

class ContentProducerInfo {
  final String? producerName;
  final String? businessName;
  final String? specialization;
  final List<String>? serviceTypes;
  final int? yearsOfExperience;
  final int? numberOfProductions;
  final String? portfolioLink;
  final String? availabilityType;
  final String? businessAddress;
  final String? businessWebsite;
  final String? idType;
  final String? idNumber;
  final String? tinNumber;

  ContentProducerInfo({
    this.producerName,
    this.businessName,
    this.specialization,
    this.serviceTypes,
    this.yearsOfExperience,
    this.numberOfProductions,
    this.portfolioLink,
    this.availabilityType,
    this.businessAddress,
    this.businessWebsite,
    this.idType,
    this.idNumber,
    this.tinNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      if (producerName != null) 'producerName': producerName,
      if (businessName != null) 'businessName': businessName,
      if (specialization != null) 'specialization': specialization,
      if (serviceTypes != null) 'serviceTypes': serviceTypes,
      if (yearsOfExperience != null) 'yearsOfExperience': yearsOfExperience,
      if (numberOfProductions != null)
        'numberOfProductions': numberOfProductions,
      if (portfolioLink != null) 'portfolioLink': portfolioLink,
      if (availabilityType != null) 'availabilityType': availabilityType,
      if (businessAddress != null) 'businessAddress': businessAddress,
      if (businessWebsite != null) 'businessWebsite': businessWebsite,
      if (idType != null) 'idType': idType,
      if (idNumber != null) 'idNumber': idNumber,
      if (tinNumber != null) 'tinNumber': tinNumber,
    };
  }

  factory ContentProducerInfo.fromJson(Map<String, dynamic> json) {
    return ContentProducerInfo(
      producerName: json['producerName'],
      businessName: json['businessName'],
      specialization: json['specialization'],
      serviceTypes: json['serviceTypes'] != null
          ? List<String>.from(json['serviceTypes'])
          : null,
      yearsOfExperience: json['yearsOfExperience'],
      numberOfProductions: json['numberOfProductions'],
      portfolioLink: json['portfolioLink'],
      availabilityType: json['availabilityType'],
      businessAddress: json['businessAddress'],
      businessWebsite: json['businessWebsite'],
      idType: json['idType'],
      idNumber: json['idNumber'],
      tinNumber: json['tinNumber'],
    );
  }
}

class InfluencerInfo {
  final String? displayName;
  final String? primaryPlatform;
  final String? contentCategory; // Added
  final String? niche;
  final String? audienceSizeRange; // Renamed from estimatedReach
  final double? averageEngagementRate; // Changed to double?
  final List<String>? contentFormats; // Changed to List<String>?
  final String? portfolioLink; // Renamed from portfolioMediaKitLink
  final String? availabilityType; // Renamed from availability

  InfluencerInfo({
    this.displayName,
    this.primaryPlatform,
    this.contentCategory,
    this.niche,
    this.audienceSizeRange,
    this.averageEngagementRate,
    this.contentFormats,
    this.portfolioLink,
    this.availabilityType,
  });

  Map<String, dynamic> toJson() {
    return {
      if (displayName != null) 'displayName': displayName,
      if (primaryPlatform != null) 'primaryPlatform': primaryPlatform,
      if (contentCategory != null) 'contentCategory': contentCategory,
      if (niche != null) 'niche': niche,
      if (audienceSizeRange != null) 'audienceSizeRange': audienceSizeRange,
      if (averageEngagementRate != null)
        'averageEngagementRate': averageEngagementRate,
      if (contentFormats != null) 'contentFormats': contentFormats,
      if (portfolioLink != null) 'portfolioLink': portfolioLink,
      if (availabilityType != null) 'availabilityType': availabilityType,
    };
  }

  factory InfluencerInfo.fromJson(Map<String, dynamic> json) {
    return InfluencerInfo(
      displayName: json['displayName'],
      primaryPlatform: json['primaryPlatform'],
      contentCategory: json['contentCategory'],
      niche: json['niche'],
      audienceSizeRange: json['audienceSizeRange'],
      averageEngagementRate: json['averageEngagementRate']?.toDouble(),
      contentFormats: json['contentFormats'] != null
          ? List<String>.from(json['contentFormats'])
          : null,
      portfolioLink: json['portfolioLink'],
      availabilityType: json['availabilityType'],
    );
  }
}

class UGCInfo {
  final String? displayName;
  final List<String> contentStyle;
  final List<String> niches;
  final List<String> contentFormats;
  final int? yearsOfExperience; // Changed to int?
  final String? portfolioLink;
  final String availabilityType; // Renamed from availability

  UGCInfo({
    this.displayName,
    required this.contentStyle,
    required this.niches,
    required this.contentFormats,
    this.yearsOfExperience,
    this.portfolioLink,
    required this.availabilityType,
  });

  Map<String, dynamic> toJson() {
    return {
      if (displayName != null) 'displayName': displayName,
      'contentStyle': contentStyle,
      'niches': niches,
      'contentFormats': contentFormats,
      if (yearsOfExperience != null) 'yearsOfExperience': yearsOfExperience,
      if (portfolioLink != null) 'portfolioLink': portfolioLink,
      'availabilityType': availabilityType,
    };
  }

  factory UGCInfo.fromJson(Map<String, dynamic> json) {
    return UGCInfo(
      displayName: json['displayName'],
      contentStyle: List<String>.from(json['contentStyle']),
      niches: List<String>.from(json['niches']),
      contentFormats: List<String>.from(json['contentFormats']),
      yearsOfExperience: json['yearsOfExperience'],
      portfolioLink: json['portfolioLink'],
      availabilityType: json['availabilityType'],
    );
  }
}

class HostInfo {
  final String? businessName;
  final String? permitNumber; // Renamed from signagePermitNumber
  final String? businessAddress;
  final String? businessWebsite;
  final String? industry;
  final List<String>? operatingCities; // Added
  final int? yearsOfOperation; // Added
  final String? idType; // Added
  final String? idNumber; // Added
  final String? tinNumber; // Added

  HostInfo({
    this.businessName,
    this.permitNumber,
    this.businessAddress,
    this.businessWebsite,
    this.industry,
    this.operatingCities,
    this.yearsOfOperation,
    this.idType,
    this.idNumber,
    this.tinNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      if (businessName != null) 'businessName': businessName,
      if (permitNumber != null) 'permitNumber': permitNumber,
      if (businessAddress != null) 'businessAddress': businessAddress,
      if (businessWebsite != null) 'businessWebsite': businessWebsite,
      if (industry != null) 'industry': industry,
      if (operatingCities != null) 'operatingCities': operatingCities,
      if (yearsOfOperation != null) 'yearsOfOperation': yearsOfOperation,
      if (idType != null) 'idType': idType,
      if (idNumber != null) 'idNumber': idNumber,
      if (tinNumber != null) 'tinNumber': tinNumber,
    };
  }

  factory HostInfo.fromJson(Map<String, dynamic> json) {
    return HostInfo(
      businessName: json['businessName'],
      permitNumber: json['permitNumber'],
      businessAddress: json['businessAddress'],
      businessWebsite: json['businessWebsite'],
      industry: json['industry'],
      operatingCities: json['operatingCities'] != null
          ? List<String>.from(json['operatingCities'])
          : null,
      yearsOfOperation: json['yearsOfOperation'],
      idType: json['idType'],
      idNumber: json['idNumber'],
      tinNumber: json['tinNumber'],
    );
  }
}

class TVStationInfo {
  final String businessName; // Renamed from stationName
  final String businessAddress;
  final String rcNumber;
  final String tinNumber;
  final String contactPhone; // Renamed from telephoneNumber
  final String? businessWebsite; // Renamed from website
  final String broadcastType;
  final String channelType;
  final List<String> operatingRegions;
  final List<String> contentFocus;
  final int? yearsOfOperation; // Changed to int?
  final int? averageDailyViewership; // Changed to int?

  TVStationInfo({
    required this.businessName,
    required this.businessAddress,
    required this.rcNumber,
    required this.tinNumber,
    required this.contactPhone,
    this.businessWebsite,
    required this.broadcastType,
    required this.channelType,
    required this.operatingRegions,
    required this.contentFocus,
    this.yearsOfOperation,
    this.averageDailyViewership,
  });

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'businessAddress': businessAddress,
      'rcNumber': rcNumber,
      'tinNumber': tinNumber,
      'contactPhone': contactPhone,
      if (businessWebsite != null) 'businessWebsite': businessWebsite,
      'broadcastType': broadcastType,
      'channelType': channelType,
      'operatingRegions': operatingRegions,
      'contentFocus': contentFocus,
      if (yearsOfOperation != null) 'yearsOfOperation': yearsOfOperation,
      if (averageDailyViewership != null)
        'averageDailyViewership': averageDailyViewership,
    };
  }

  factory TVStationInfo.fromJson(Map<String, dynamic> json) {
    return TVStationInfo(
      businessName: json['businessName'],
      businessAddress: json['businessAddress'],
      rcNumber: json['rcNumber'],
      tinNumber: json['tinNumber'],
      contactPhone: json['contactPhone'],
      businessWebsite: json['businessWebsite'],
      broadcastType: json['broadcastType'],
      channelType: json['channelType'],
      operatingRegions: List<String>.from(json['operatingRegions']),
      contentFocus: List<String>.from(json['contentFocus']),
      yearsOfOperation: json['yearsOfOperation'],
      averageDailyViewership: json['averageDailyViewership'],
    );
  }
}

class RadioStationInfo {
  final String businessName; // Renamed from stationName
  final String businessAddress;
  final String rcNumber;
  final String tinNumber;
  final String contactPhone;
  final String? businessWebsite; // Renamed from website
  final String broadcastBand;
  final String primaryLanguage;
  final List<String> operatingRegions;
  final List<String> contentFocus;
  final int? yearsOfOperation; // Changed to int?
  final int? averageDailyListenership; // Changed to int?

  RadioStationInfo({
    required this.businessName,
    required this.businessAddress,
    required this.rcNumber,
    required this.tinNumber,
    required this.contactPhone,
    this.businessWebsite,
    required this.broadcastBand,
    required this.primaryLanguage,
    required this.operatingRegions,
    required this.contentFocus,
    this.yearsOfOperation,
    this.averageDailyListenership,
  });

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'businessAddress': businessAddress,
      'rcNumber': rcNumber,
      'tinNumber': tinNumber,
      'contactPhone': contactPhone,
      if (businessWebsite != null) 'businessWebsite': businessWebsite,
      'broadcastBand': broadcastBand,
      'primaryLanguage': primaryLanguage,
      'operatingRegions': operatingRegions,
      'contentFocus': contentFocus,
      if (yearsOfOperation != null) 'yearsOfOperation': yearsOfOperation,
      if (averageDailyListenership != null)
        'averageDailyListenership': averageDailyListenership,
    };
  }

  factory RadioStationInfo.fromJson(Map<String, dynamic> json) {
    return RadioStationInfo(
      businessName: json['businessName'],
      businessAddress: json['businessAddress'],
      rcNumber: json['rcNumber'],
      tinNumber: json['tinNumber'],
      contactPhone: json['contactPhone'],
      businessWebsite: json['businessWebsite'],
      broadcastBand: json['broadcastBand'],
      primaryLanguage: json['primaryLanguage'],
      operatingRegions: List<String>.from(json['operatingRegions']),
      contentFocus: List<String>.from(json['contentFocus']),
      yearsOfOperation: json['yearsOfOperation'],
      averageDailyListenership: json['averageDailyListenership'],
    );
  }
}

class MediaHouseInfo {
  final String businessName;
  final String businessAddress;
  final String rcNumber;
  final String tinNumber;
  final String contactPhone;
  final String? businessWebsite; // Renamed from website
  final List<String> mediaTypes;
  final List<String> operatingRegions;
  final int? yearsOfOperation; // Changed to int?
  final List<String> contentFocus;
  final int? estimatedMonthlyReach; // Changed to int?

  MediaHouseInfo({
    required this.businessName,
    required this.businessAddress,
    required this.rcNumber,
    required this.tinNumber,
    required this.contactPhone,
    this.businessWebsite,
    required this.mediaTypes,
    required this.operatingRegions,
    this.yearsOfOperation,
    required this.contentFocus,
    this.estimatedMonthlyReach,
  });

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'businessAddress': businessAddress,
      'rcNumber': rcNumber,
      'tinNumber': tinNumber,
      'contactPhone': contactPhone,
      if (businessWebsite != null) 'businessWebsite': businessWebsite,
      'mediaTypes': mediaTypes,
      'operatingRegions': operatingRegions,
      if (yearsOfOperation != null) 'yearsOfOperation': yearsOfOperation,
      'contentFocus': contentFocus,
      if (estimatedMonthlyReach != null)
        'estimatedMonthlyReach': estimatedMonthlyReach,
    };
  }

  factory MediaHouseInfo.fromJson(Map<String, dynamic> json) {
    return MediaHouseInfo(
      businessName: json['businessName'],
      businessAddress: json['businessAddress'],
      rcNumber: json['rcNumber'],
      tinNumber: json['tinNumber'],
      contactPhone: json['contactPhone'],
      businessWebsite: json['businessWebsite'],
      mediaTypes: List<String>.from(json['mediaTypes']),
      operatingRegions: List<String>.from(json['operatingRegions']),
      yearsOfOperation: json['yearsOfOperation'],
      contentFocus: List<String>.from(json['contentFocus']),
      estimatedMonthlyReach: json['estimatedMonthlyReach'],
    );
  }
}

class CreativeInfo {
  final String? displayName;
  final String? creativeType;
  final List<String>? skills;
  final String? specialization;
  final List<String>? toolsUsed;
  final int? yearsOfExperience;
  final int? numberOfProjects;
  final String? portfolioLink;
  final String? availabilityType;

  CreativeInfo({
    this.displayName,
    this.creativeType,
    this.skills,
    this.specialization,
    this.toolsUsed,
    this.yearsOfExperience,
    this.numberOfProjects,
    this.portfolioLink,
    this.availabilityType,
  });

  Map<String, dynamic> toJson() {
    return {
      if (displayName != null) 'displayName': displayName,
      if (creativeType != null) 'creativeType': creativeType,
      if (skills != null) 'skills': skills,
      if (specialization != null) 'specialization': specialization,
      if (toolsUsed != null) 'toolsUsed': toolsUsed,
      if (yearsOfExperience != null) 'yearsOfExperience': yearsOfExperience,
      if (numberOfProjects != null) 'numberOfProjects': numberOfProjects,
      if (portfolioLink != null) 'portfolioLink': portfolioLink,
      if (availabilityType != null) 'availabilityType': availabilityType,
    };
  }

  factory CreativeInfo.fromJson(Map<String, dynamic> json) {
    return CreativeInfo(
      displayName: json['displayName'],
      creativeType: json['creativeType'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      specialization: json['specialization'],
      toolsUsed: json['toolsUsed'] != null
          ? List<String>.from(json['toolsUsed'])
          : null,
      yearsOfExperience: json['yearsOfExperience'],
      numberOfProjects: json['numberOfProjects'],
      portfolioLink: json['portfolioLink'],
      availabilityType: json['availabilityType'],
    );
  }
}

class DesignerInfo {
  final String? businessName;
  final String? businessAddress;
  final String? businessWebsite;
  final String? telephoneNumber;
  final String? portfolioUrl; // Renamed from portfolioLink
  final String? bio;
  final String? skillTags; // String in JSON, not List
  final String? experienceLevel; // "Senior"
  final String? pricingModel; // "Per Project"
  final double? price; // 50000 (int/double)

  DesignerInfo({
    this.businessName,
    this.businessAddress,
    this.businessWebsite,
    this.telephoneNumber,
    this.portfolioUrl,
    this.bio,
    this.skillTags,
    this.experienceLevel,
    this.pricingModel,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      if (businessName != null) 'businessName': businessName,
      if (businessAddress != null) 'businessAddress': businessAddress,
      if (businessWebsite != null) 'businessWebsite': businessWebsite,
      if (telephoneNumber != null) 'telephoneNumber': telephoneNumber,
      if (portfolioUrl != null) 'portfolioUrl': portfolioUrl,
      if (bio != null) 'bio': bio,
      if (skillTags != null) 'skillTags': skillTags,
      if (experienceLevel != null) 'experienceLevel': experienceLevel,
      if (pricingModel != null) 'pricingModel': pricingModel,
      if (price != null) 'price': price,
    };
  }

  factory DesignerInfo.fromJson(Map<String, dynamic> json) {
    return DesignerInfo(
      businessName: json['businessName'],
      businessAddress: json['businessAddress'],
      businessWebsite: json['businessWebsite'],
      telephoneNumber: json['telephoneNumber'],
      portfolioUrl: json['portfolioUrl'],
      bio: json['bio'],
      skillTags: json['skillTags'],
      experienceLevel: json['experienceLevel'],
      pricingModel: json['pricingModel'],
      price: json['price']?.toDouble(),
    );
  }
}

class TalentManagerInfo {
  final String? managerDisplayName;
  final String? businessName;
  final String? businessAddress;
  final String? businessTelephoneNumber;
  final String? numberOfTalentsManaged; // Dropdown value
  final List<String> talentCategories;
  final String? yearsOfExperience;
  final String? website;
  final String? businessRegistrationNumber;
  final String? tinNumber;

  TalentManagerInfo({
    this.managerDisplayName,
    this.businessName,
    this.businessAddress,
    this.businessTelephoneNumber,
    this.numberOfTalentsManaged,
    required this.talentCategories,
    this.yearsOfExperience,
    this.website,
    this.businessRegistrationNumber,
    this.tinNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      if (managerDisplayName != null) 'managerDisplayName': managerDisplayName,
      if (businessName != null) 'businessName': businessName,
      if (businessAddress != null) 'businessAddress': businessAddress,
      if (businessTelephoneNumber != null)
        'businessTelephoneNumber': businessTelephoneNumber,
      if (numberOfTalentsManaged != null)
        'numberOfTalentsManaged': numberOfTalentsManaged,
      'talentCategories': talentCategories,
      if (yearsOfExperience != null) 'yearsOfExperience': yearsOfExperience,
      if (website != null) 'website': website,
      if (businessRegistrationNumber != null)
        'businessRegistrationNumber': businessRegistrationNumber,
      if (tinNumber != null) 'tinNumber': tinNumber,
    };
  }

  factory TalentManagerInfo.fromJson(Map<String, dynamic> json) {
    return TalentManagerInfo(
      managerDisplayName: json['managerDisplayName'],
      businessName: json['businessName'],
      businessAddress: json['businessAddress'],
      businessTelephoneNumber: json['businessTelephoneNumber'],
      numberOfTalentsManaged: json['numberOfTalentsManaged'],
      talentCategories: List<String>.from(json['talentCategories']),
      yearsOfExperience: json['yearsOfExperience'],
      website: json['website'],
      businessRegistrationNumber: json['businessRegistrationNumber'],
      tinNumber: json['tinNumber'],
    );
  }
}

class SignUpRequest {
  final String role;
  final String authProvider;
  final String accountType;
  final ArtistInfo? artistInfo;
  final AdvertiserInfo? advertiserInfo;
  final ScreenBillboardInfo? screenBillboardInfo;
  final ContentProducerInfo? contentProducerInfo;
  final InfluencerInfo? influencerInfo;
  final UGCInfo? ugcInfo;
  final HostInfo? hostInfo;
  final TVStationInfo? tvStationInfo;
  final RadioStationInfo? radioStationInfo;
  final MediaHouseInfo? mediaHouseInfo;
  final CreativeInfo? creativeInfo;
  final DesignerInfo? designerInfo;
  final TalentManagerInfo? talentManagerInfo;
  final String name;
  final String emailAddress;
  final String phoneNumber;
  final String password;
  final String country;
  final String? state;
  final String? city;
  final String? address;
  final String? referredById;
  final String? idType;
  final String? idNumber;
  final String? ninNumber;
  final String? tinNumber;

  SignUpRequest({
    required this.role,
    this.authProvider = 'INTERNAL',
    required this.accountType,
    this.artistInfo,
    this.advertiserInfo,
    this.screenBillboardInfo,
    this.contentProducerInfo,
    this.influencerInfo,
    this.ugcInfo,
    this.hostInfo,
    this.tvStationInfo,
    this.radioStationInfo,
    this.mediaHouseInfo,
    this.creativeInfo,
    this.designerInfo,
    this.talentManagerInfo,
    required this.name,
    required this.emailAddress,
    required this.phoneNumber,
    required this.password,
    this.country = 'Nigeria',
    this.state,
    this.city,
    this.address,
    this.referredById,
    this.idType,
    this.idNumber,
    this.ninNumber,
    this.tinNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'authProvider': authProvider,
      'accountType': accountType,
      if (artistInfo != null) 'artistInfo': artistInfo!.toJson(),
      if (advertiserInfo != null) 'advertiserInfo': advertiserInfo!.toJson(),
      if (screenBillboardInfo != null)
        'screenBillboardInfo': screenBillboardInfo!.toJson(),
      if (contentProducerInfo != null)
        'producerInfo': contentProducerInfo!.toJson(),
      if (influencerInfo != null) 'influencerInfo': influencerInfo!.toJson(),
      if (ugcInfo != null) 'ugcInfo': ugcInfo!.toJson(),
      if (hostInfo != null) 'hostInfo': hostInfo!.toJson(),
      if (tvStationInfo != null) 'tvStationInfo': tvStationInfo!.toJson(),
      if (radioStationInfo != null)
        'radioStationInfo': radioStationInfo!.toJson(),
      if (mediaHouseInfo != null) 'mediaHouseInfo': mediaHouseInfo!.toJson(),
      if (creativeInfo != null) 'creativeInfo': creativeInfo!.toJson(),
      if (designerInfo != null) 'designerInfo': designerInfo!.toJson(),
      if (talentManagerInfo != null)
        'talentManagerInfo': talentManagerInfo!.toJson(),
      'name': name,
      'emailAddress': emailAddress,
      'phoneNumber': phoneNumber,
      'password': password,
      'country': country,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (address != null) 'address': address,
      if (referredById != null) 'referredById': referredById,
      if (idType != null) 'idType': idType,
      if (idNumber != null) 'idNumber': idNumber,
      if (ninNumber != null) 'ninNumber': ninNumber,
      if (tinNumber != null) 'tinNumber': tinNumber,
    };
  }

  factory SignUpRequest.fromJson(Map<String, dynamic> json) {
    return SignUpRequest(
      role: json['role'],
      authProvider: json['authProvider'] ?? 'INTERNAL',
      accountType: json['accountType'] ?? 'INDIVIDUAL',
      artistInfo: json['artistInfo'] != null
          ? ArtistInfo.fromJson(json['artistInfo'])
          : null,
      advertiserInfo: json['advertiserInfo'] != null
          ? AdvertiserInfo.fromJson(json['advertiserInfo'])
          : null,
      screenBillboardInfo: json['screenBillboardInfo'] != null
          ? ScreenBillboardInfo.fromJson(json['screenBillboardInfo'])
          : null,
      contentProducerInfo: json['producerInfo'] != null
          ? ContentProducerInfo.fromJson(json['producerInfo'])
          : null,
      influencerInfo: json['influencerInfo'] != null
          ? InfluencerInfo.fromJson(json['influencerInfo'])
          : null,
      ugcInfo: json['ugcInfo'] != null
          ? UGCInfo.fromJson(json['ugcInfo'])
          : null,
      hostInfo: json['hostInfo'] != null
          ? HostInfo.fromJson(json['hostInfo'])
          : null,
      tvStationInfo: json['tvStationInfo'] != null
          ? TVStationInfo.fromJson(json['tvStationInfo'])
          : null,
      radioStationInfo: json['radioStationInfo'] != null
          ? RadioStationInfo.fromJson(json['radioStationInfo'])
          : null,
      mediaHouseInfo: json['mediaHouseInfo'] != null
          ? MediaHouseInfo.fromJson(json['mediaHouseInfo'])
          : null,
      creativeInfo: json['creativeInfo'] != null
          ? CreativeInfo.fromJson(json['creativeInfo'])
          : null,
      designerInfo: json['designerInfo'] != null
          ? DesignerInfo.fromJson(json['designerInfo'])
          : null,
      talentManagerInfo: json['talentManagerInfo'] != null
          ? TalentManagerInfo.fromJson(json['talentManagerInfo'])
          : null,
      name: json['name'],
      emailAddress: json['emailAddress'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      country: json['country'] ?? 'Nigeria',
      state: json['state'],
      city: json['city'],
      address: json['address'],
      referredById: json['referredById'],
      idType: json['idType'],
      idNumber: json['idNumber'],
      ninNumber: json['ninNumber'],
      tinNumber: json['tinNumber'],
    );
  }

  SignUpRequest copyWith({
    String? role,
    String? authProvider,
    String? accountType,
    ArtistInfo? artistInfo,
    AdvertiserInfo? advertiserInfo,
    ScreenBillboardInfo? screenBillboardInfo,
    ContentProducerInfo? contentProducerInfo,
    InfluencerInfo? influencerInfo,
    UGCInfo? ugcInfo,
    HostInfo? hostInfo,
    TVStationInfo? tvStationInfo,
    RadioStationInfo? radioStationInfo,
    MediaHouseInfo? mediaHouseInfo,
    CreativeInfo? creativeInfo,
    DesignerInfo? designerInfo,
    TalentManagerInfo? talentManagerInfo,
    String? name,
    String? emailAddress,
    String? phoneNumber,
    String? password,
    String? country,
    String? state,
    String? city,
    String? address,
    String? referredById,
    String? idType,
    String? idNumber,
    String? ninNumber,
    String? tinNumber,
  }) {
    return SignUpRequest(
      role: role ?? this.role,
      authProvider: authProvider ?? this.authProvider,
      accountType: accountType ?? this.accountType,
      artistInfo: artistInfo ?? this.artistInfo,
      advertiserInfo: advertiserInfo ?? this.advertiserInfo,
      screenBillboardInfo: screenBillboardInfo ?? this.screenBillboardInfo,
      contentProducerInfo: contentProducerInfo ?? this.contentProducerInfo,
      influencerInfo: influencerInfo ?? this.influencerInfo,
      ugcInfo: ugcInfo ?? this.ugcInfo,
      hostInfo: hostInfo ?? this.hostInfo,
      tvStationInfo: tvStationInfo ?? this.tvStationInfo,
      radioStationInfo: radioStationInfo ?? this.radioStationInfo,
      mediaHouseInfo: mediaHouseInfo ?? this.mediaHouseInfo,
      creativeInfo: creativeInfo ?? this.creativeInfo,
      designerInfo: designerInfo ?? this.designerInfo,
      talentManagerInfo: talentManagerInfo ?? this.talentManagerInfo,
      name: name ?? this.name,
      emailAddress: emailAddress ?? this.emailAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      address: address ?? this.address,
      referredById: referredById ?? this.referredById,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
      ninNumber: ninNumber ?? this.ninNumber,
      tinNumber: tinNumber ?? this.tinNumber,
    );
  }
}

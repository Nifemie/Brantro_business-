class ProducerModel {
  final int id;
  final String name;
  final String? phoneNumber;
  final String emailAddress;
  final String? alias;
  final String? bio;
  final String role;
  final String? avatarUrl;
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final bool isVerified;
  final String status;
  final double? averageRating;
  final int? totalLikes;
  final ProducerAdditionalInfo? additionalInfo;

  ProducerModel({
    required this.id,
    required this.name,
    this.phoneNumber,
    required this.emailAddress,
    this.alias,
    this.bio,
    required this.role,
    this.avatarUrl,
    this.country,
    this.state,
    this.city,
    this.address,
    required this.isVerified,
    required this.status,
    this.averageRating,
    this.totalLikes,
    this.additionalInfo,
  });

  factory ProducerModel.fromJson(Map<String, dynamic> json) {
    return ProducerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      emailAddress: json['emailAddress'] as String,
      alias: json['alias'] as String?,
      bio: json['bio'] as String?,
      role: json['role'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      status: json['status'] as String,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      totalLikes: json['totalLikes'] as int?,
      additionalInfo: json['additionalInfo'] != null
          ? ProducerAdditionalInfo.fromJson(
              json['additionalInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'alias': alias,
      'bio': bio,
      'role': role,
      'avatarUrl': avatarUrl,
      'country': country,
      'state': state,
      'city': city,
      'address': address,
      'isVerified': isVerified,
      'status': status,
      'averageRating': averageRating,
      'totalLikes': totalLikes,
      'additionalInfo': additionalInfo?.toJson(),
    };
  }
}

class ProducerAdditionalInfo {
  final String? idType;
  final String? idNumber;
  final String? tinNumber;
  final String? businessName;
  final List<String>? serviceTypes;
  final String? portfolioLink;
  final String? businessAddress;
  final String? businessWebsite;
  final int? yearsOfExperience;
  final int? numberOfProductions;

  ProducerAdditionalInfo({
    this.idType,
    this.idNumber,
    this.tinNumber,
    this.businessName,
    this.serviceTypes,
    this.portfolioLink,
    this.businessAddress,
    this.businessWebsite,
    this.yearsOfExperience,
    this.numberOfProductions,
  });

  factory ProducerAdditionalInfo.fromJson(Map<String, dynamic> json) {
    return ProducerAdditionalInfo(
      idType: json['idType'] as String?,
      idNumber: json['idNumber'] as String?,
      tinNumber: json['tinNumber'] as String?,
      businessName: json['businessName'] as String?,
      serviceTypes: (json['serviceTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      portfolioLink: json['portfolioLink'] as String?,
      businessAddress: json['businessAddress'] as String?,
      businessWebsite: json['businessWebsite'] as String?,
      yearsOfExperience: json['yearsOfExperience'] as int?,
      numberOfProductions: json['numberOfProductions'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idType': idType,
      'idNumber': idNumber,
      'tinNumber': tinNumber,
      'businessName': businessName,
      'serviceTypes': serviceTypes,
      'portfolioLink': portfolioLink,
      'businessAddress': businessAddress,
      'businessWebsite': businessWebsite,
      'yearsOfExperience': yearsOfExperience,
      'numberOfProductions': numberOfProductions,
    };
  }
}

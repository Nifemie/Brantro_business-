class ServiceModel {
  final String id;
  final int categoryId;
  final String title;
  final String description;
  final String specifications;
  final String type;
  final List<String> features;
  final List<String> requirements;
  final double price;
  final String pricingUnit;
  final double discount;
  final List<String> coverageAreas;
  final int estimatedReach;
  final int deliveryTime;
  final String deliveryTimeUnit;
  final int revisionCount;
  final List<String> deliveryFormats;
  final double averageRating;
  final int totalLikes;
  final String thumbnail;
  final String sampleUrl;
  final List<String> gallery;
  final List<String> tags;
  final String status;
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerEmail;
  final String? ownerAddress;
  final String? ownerAvatarUrl;
  final String? ownerCoverUrl;
  final String? ownerRole;
  final String? category;
  final DateTime createdAt;

  ServiceModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.specifications,
    required this.type,
    this.category,
    required this.features,
    required this.requirements,
    required this.price,
    required this.pricingUnit,
    required this.discount,
    required this.coverageAreas,
    required this.estimatedReach,
    required this.deliveryTime,
    required this.deliveryTimeUnit,
    required this.revisionCount,
    required this.deliveryFormats,
    required this.averageRating,
    required this.totalLikes,
    required this.thumbnail,
    required this.sampleUrl,
    required this.gallery,
    required this.tags,
    required this.status,
    this.ownerName,
    this.ownerPhone,
    this.ownerEmail,
    this.ownerAddress,
    this.ownerAvatarUrl,
    this.ownerCoverUrl,
    this.ownerRole,
    required this.createdAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? '',
      categoryId: int.tryParse(json['categoryId']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      specifications: json['specifications']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      category: json['category']?.toString() ?? json['type']?.toString(),
      features: json['features'] != null ? List<String>.from(json['features']) : [],
      requirements: json['requirements'] != null ? List<String>.from(json['requirements']) : [],
      price: double.tryParse((json['price'] ?? 0).toString()) ?? 0.0,
      pricingUnit: json['pricingUnit']?.toString() ?? '',
      discount: double.tryParse((json['discount'] ?? 0).toString()) ?? 0.0,
      coverageAreas: json['coverageAreas'] != null ? List<String>.from(json['coverageAreas']) : [],
      estimatedReach: int.tryParse(json['estimatedReach']?.toString() ?? '') ?? 0,
      deliveryTime: int.tryParse(json['deliveryTime']?.toString() ?? '') ?? 0,
      deliveryTimeUnit: json['deliveryTimeUnit']?.toString() ?? 'days',
      revisionCount: int.tryParse(json['revisionCount']?.toString() ?? '') ?? 0,
      deliveryFormats: json['deliveryFormats'] != null ? List<String>.from(json['deliveryFormats']) : [],
      averageRating: double.tryParse((json['averageRating'] ?? 0).toString()) ?? 0.0,
      totalLikes: int.tryParse(json['totalLikes']?.toString() ?? '') ?? 0,
      thumbnail: json['thumbnail']?.toString() ?? '',
      sampleUrl: json['sampleUrl']?.toString() ?? '',
      gallery: json['gallery'] != null ? List<String>.from(json['gallery']) : [],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      status: json['status']?.toString() ?? '',
      ownerName: json['createdBy']?['name']?.toString(),
      ownerPhone: json['createdBy']?['phoneNumber']?.toString(),
      ownerEmail: json['createdBy']?['emailAddress']?.toString(),
      ownerAddress: json['createdBy']?['address']?.toString(),
      ownerAvatarUrl: json['createdBy']?['avatarUrl']?.toString(),
      ownerCoverUrl: json['createdBy']?['coverUrl']?.toString(),
      ownerRole: json['createdBy']?['role']?.toString(),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'title': title,
      'description': description,
      'specifications': specifications,
      'type': type,
      'features': features,
      'requirements': requirements,
      'price': price,
      'pricingUnit': pricingUnit,
      'discount': discount,
      'coverageAreas': coverageAreas,
      'estimatedReach': estimatedReach,
      'deliveryTime': deliveryTime,
      'deliveryTimeUnit': deliveryTimeUnit,
      'revisionCount': revisionCount,
      'deliveryFormats': deliveryFormats,
      'averageRating': averageRating,
      'totalLikes': totalLikes,
      'thumbnail': thumbnail,
      'sampleUrl': sampleUrl,
      'gallery': gallery,
      'tags': tags,
      'status': status,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'ownerAddress': ownerAddress,
      'ownerAvatarUrl': ownerAvatarUrl,
      'ownerCoverUrl': ownerCoverUrl,
      'ownerRole': ownerRole,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

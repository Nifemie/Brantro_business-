class DigitalScreenModel {
  final int id;
  final String title;
  final String type;
  final int categoryId;
  final String description;
  final String? features;
  final String? specifications;
  final String? thumbnail;
  final String? videoClip;
  final String address;
  final String city;
  final String state;
  final String country;
  final double? latitude;
  final double? longitude;
  final double baseRateAmount;
  final String baseRateUnit;
  final double averageRating;
  final int totalLikes;
  final String status;
  final int ownerId;
  final ScreenOwner? owner;
  final ScreenCategory? category;

  DigitalScreenModel({
    required this.id,
    required this.title,
    required this.type,
    required this.categoryId,
    required this.description,
    this.features,
    this.specifications,
    this.thumbnail,
    this.videoClip,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    this.latitude,
    this.longitude,
    required this.baseRateAmount,
    required this.baseRateUnit,
    required this.averageRating,
    required this.totalLikes,
    required this.status,
    required this.ownerId,
    this.owner,
    this.category,
  });

  factory DigitalScreenModel.fromJson(Map<String, dynamic> json) {
    return DigitalScreenModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      type: json['type'] ?? 'SCREEN',
      categoryId: json['categoryId'] ?? 0,
      description: json['description'] ?? '',
      features: json['features'],
      specifications: json['specifications'],
      thumbnail: json['thumbnail'],
      videoClip: json['videoClip'],
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      baseRateAmount: (json['baseRateAmount'] as num?)?.toDouble() ?? 0.0,
      baseRateUnit: json['baseRateUnit'] ?? 'DAY',
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalLikes: json['totalLikes'] ?? 0,
      status: json['status'] ?? 'ACTIVE',
      ownerId: json['ownerId'] ?? 0,
      owner: json['owner'] != null
          ? ScreenOwner.fromJson(json['owner'])
          : null,
      category: json['category'] != null
          ? ScreenCategory.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'categoryId': categoryId,
      'description': description,
      'features': features,
      'specifications': specifications,
      'thumbnail': thumbnail,
      'videoClip': videoClip,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'baseRateAmount': baseRateAmount,
      'baseRateUnit': baseRateUnit,
      'averageRating': averageRating,
      'totalLikes': totalLikes,
      'status': status,
      'ownerId': ownerId,
      'owner': owner?.toJson(),
      'category': category?.toJson(),
    };
  }
}

class ScreenOwner {
  final int id;
  final String name;
  final String? avatarUrl;

  ScreenOwner({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory ScreenOwner.fromJson(Map<String, dynamic> json) {
    return ScreenOwner(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }
}

class ScreenCategory {
  final int id;
  final String name;
  final String type;
  final String? description;

  ScreenCategory({
    required this.id,
    required this.name,
    required this.type,
    this.description,
  });

  factory ScreenCategory.fromJson(Map<String, dynamic> json) {
    return ScreenCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      type: json['type'] ?? 'LOCATION',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
    };
  }
}

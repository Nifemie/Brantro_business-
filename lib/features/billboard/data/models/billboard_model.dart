class BillboardModel {
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
  final BillboardOwner? owner;
  final BillboardCategory? category;

  BillboardModel({
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

  factory BillboardModel.fromJson(Map<String, dynamic> json) {
    return BillboardModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      type: json['type'] ?? 'BILLBOARD',
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
          ? BillboardOwner.fromJson(json['owner'])
          : null,
      category: json['category'] != null
          ? BillboardCategory.fromJson(json['category'])
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

  // Helper method to get full thumbnail URL
  String get thumbnailUrl {
    if (thumbnail == null || thumbnail!.isEmpty) {
      return 'assets/promotions/billboard1.jpg'; // Default fallback
    }
    // If already a full URL, return as is
    if (thumbnail!.startsWith('http')) {
      return thumbnail!;
    }
    // Remove leading slash if present to avoid double slash
    final cleanPath = thumbnail!.startsWith('/') ? thumbnail!.substring(1) : thumbnail!;
    return 'https://realta360.b-cdn.net/$cleanPath';
  }

  // Helper method to get clean description without HTML tags
  String get cleanDescription {
    if (description.isEmpty) return '';
    // Remove HTML tags using regex
    return description
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove all HTML tags
        .replaceAll('&nbsp;', ' ') // Replace non-breaking spaces
        .replaceAll('&amp;', '&') // Replace ampersand
        .replaceAll('&lt;', '<') // Replace less than
        .replaceAll('&gt;', '>') // Replace greater than
        .replaceAll('&quot;', '"') // Replace quotes
        .trim();
  }

  // Helper method to get formatted price
  String get formattedPrice {
    if (baseRateAmount == 0) return 'Contact for pricing';
    return '₦${baseRateAmount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  // Helper method to get full location string
  String get fullLocation {
    return [city, state, country].where((e) => e.isNotEmpty).join(', ');
  }
}

class BillboardOwner {
  final int id;
  final String name;
  final String? avatarUrl;

  BillboardOwner({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory BillboardOwner.fromJson(Map<String, dynamic> json) {
    return BillboardOwner(
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

class BillboardCategory {
  final int id;
  final String name;
  final String type;
  final String? description;

  BillboardCategory({
    required this.id,
    required this.name,
    required this.type,
    this.description,
  });

  factory BillboardCategory.fromJson(Map<String, dynamic> json) {
    return BillboardCategory(
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

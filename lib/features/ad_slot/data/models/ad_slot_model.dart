class Platform {
  final String name;
  final String handle;

  Platform({
    required this.name,
    required this.handle,
  });

  factory Platform.fromJson(Map<String, dynamic> json) {
    return Platform(
      name: json['name'] ?? '',
      handle: json['handle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'handle': handle,
    };
  }
}

class AdSlot {
  final int id;
  final int userId;
  final String title;
  final String description;
  final List<String> features;
  final String partnerType;
  final List<Platform> platforms;
  final List<String> contentTypes;
  final String price;
  final String duration;
  final int maxRevisions;
  final bool isActive;
  final List<String> coverageAreas;
  final String audienceSize;
  final String? timeWindow;
  final String status;
  final Map<String, dynamic>? user;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdSlot({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.features,
    required this.partnerType,
    required this.platforms,
    required this.contentTypes,
    required this.price,
    required this.duration,
    required this.maxRevisions,
    required this.isActive,
    required this.coverageAreas,
    required this.audienceSize,
    this.timeWindow,
    required this.status,
    this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdSlot.fromJson(Map<String, dynamic> json) {
    // Parse platforms - handle both string array and object array formats
    List<Platform> parsedPlatforms = [];
    if (json['platforms'] != null) {
      final platformsData = json['platforms'] as List;
      for (var item in platformsData) {
        if (item is String) {
          // Backend sends string format: ["Instagram", "Facebook"]
          parsedPlatforms.add(Platform(name: item, handle: ''));
        } else if (item is Map<String, dynamic>) {
          // Expected object format: [{"name": "Instagram", "handle": "@user"}]
          parsedPlatforms.add(Platform.fromJson(item));
        }
      }
    }

    // Parse coverageAreas - handle null by converting to empty array
    List<String> parsedCoverageAreas = [];
    if (json['coverageAreas'] != null) {
      parsedCoverageAreas = List<String>.from(json['coverageAreas']);
    }

    return AdSlot(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      partnerType: json['partnerType'] ?? '',
      platforms: parsedPlatforms,
      contentTypes: List<String>.from(json['contentTypes'] ?? []),
      price: json['price']?.toString() ?? '0',
      duration: json['duration'] ?? '',
      maxRevisions: json['maxRevisions'] ?? 0,
      isActive: json['isActive'] ?? false,
      coverageAreas: parsedCoverageAreas,
      audienceSize: json['audienceSize'] ?? '',
      timeWindow: json['timeWindow'],
      status: json['status'] ?? '',
      user: json['user'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  // Helper methods
  String get formattedPrice {
    try {
      final numPrice = double.parse(price);
      return '₦${numPrice.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          )}';
    } catch (e) {
      return '₦$price';
    }
  }

  Platform? get primaryPlatform => platforms.isNotEmpty ? platforms.first : null;

  String get sellerName => user?['name'] ?? 'Unknown Seller';

  String? get sellerAvatar => user?['avatarUrl'];

  String get location {
    if (coverageAreas.isEmpty) return 'Not specified';
    if (coverageAreas.length == 1) return coverageAreas.first;
    return '${coverageAreas.first} +${coverageAreas.length - 1}';
  }
}

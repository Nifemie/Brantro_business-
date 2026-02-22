class ServiceModel {
  final int id;
  final String title;
  final String description;
  final String type;
  final String price;
  final String? discount;
  final String? pricingUnit;
  final int deliveryDays;
  final int? revisionCount;
  final List<String> deliveryFormats;
  final List<String> features;
  final List<String> requirements;
  final double averageRating;
  final int totalLikes;
  final String? thumbnail;
  final String? sampleUrl;
  final List<String>? gallery;
  final List<String> tags;
  final String status;
  final ServiceCreator? createdBy;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.price,
    this.discount,
    this.pricingUnit,
    required this.deliveryDays,
    this.revisionCount,
    required this.deliveryFormats,
    required this.features,
    required this.requirements,
    required this.averageRating,
    required this.totalLikes,
    this.thumbnail,
    this.sampleUrl,
    this.gallery,
    required this.tags,
    required this.status,
    this.createdBy,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      price: json['price']?.toString() ?? '0',
      discount: json['discount']?.toString(),
      pricingUnit: json['pricingUnit'],
      deliveryDays: json['deliveryDays'] ?? 0,
      revisionCount: json['revisionCount'],
      deliveryFormats: List<String>.from(json['deliveryFormats'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      requirements: List<String>.from(json['requirements'] ?? []),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalLikes: json['totalLikes'] ?? 0,
      thumbnail: json['thumbnail'],
      sampleUrl: json['sampleUrl'],
      gallery: json['gallery'] != null ? List<String>.from(json['gallery']) : null,
      tags: List<String>.from(json['tags'] ?? []),
      status: json['status'] ?? 'ACTIVE',
      createdBy: json['createdBy'] != null
          ? ServiceCreator.fromJson(json['createdBy'])
          : null,
    );
  }

  String get formattedPrice {
    final priceValue = double.tryParse(price) ?? 0;
    return '₦${priceValue.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
  }

  String get thumbnailUrl {
    if ((thumbnail == null || thumbnail!.isEmpty)) {
      if (gallery != null && gallery!.isNotEmpty) {
        final firstImage = gallery!.first;
        if (firstImage.startsWith('http')) return firstImage;
        return 'https://realta360.b-cdn.net/$firstImage';
      }
      return '';
    }
    
    if (thumbnail!.startsWith('http')) return thumbnail!;
    // Remove leading slash if present to avoid double slash
    final cleanPath = thumbnail!.startsWith('/') ? thumbnail!.substring(1) : thumbnail!;
    return 'https://realta360.b-cdn.net/$cleanPath';
  }

  String get typeBadge {
    switch (type) {
      case 'LONG_FORM_VIDEO':
        return 'Long Form Video';
      case 'SHORT_FORM_VIDEO':
        return 'Short Form Video';
      case 'MOTION_GRAPHICS':
        return 'Motion Graphics';
      case 'VIDEO_EDITING':
        return 'Video Editing';
      case 'PRINT_DESIGN':
        return 'Print Design';
      case 'GRAPHIC_DESIGN':
        return 'Graphic Design';
      default:
        return type.replaceAll('_', ' ');
    }
  }

  String get cleanDescription {
    return description.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}

class ServiceCreator {
  final int id;
  final String name;
  final String? avatarUrl;

  ServiceCreator({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory ServiceCreator.fromJson(Map<String, dynamic> json) {
    return ServiceCreator(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      avatarUrl: json['avatarUrl'],
    );
  }
}

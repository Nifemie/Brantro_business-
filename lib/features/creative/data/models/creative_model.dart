class CreativeModel {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int favorites;
  final double price;
  final double discount;
  final int ordersCount;
  final String description;
  final List<String> features;
  final String specifications;
  final bool isActive;
  final String type;
  final String format;
  final String? fileFormat;
  final int fileSizeMB;
  final int durationInSeconds;
  final int width;
  final int height;
  final List<String> tags;
  final String ownerName;
  final String ownerBadge;
  final String ownerEmail;
  final String ownerPhone;
  final String ownerAddress;
  final String ownerLocation;
  final String? category;
  final DateTime createdAt;

  CreativeModel({
    required this.id,
    required this.name,
    required this.image,
    this.rating = 0.0,
    this.favorites = 0,
    required this.price,
    required this.discount,
    this.ordersCount = 0,
    required this.description,
    required this.features,
    required this.specifications,
    this.isActive = true,
    required this.type,
    required this.format,
    this.fileFormat,
    this.category,
    required this.fileSizeMB,
    required this.durationInSeconds,
    required this.width,
    required this.height,
    required this.tags,
    required this.ownerName,
    required this.ownerBadge,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.ownerAddress,
    required this.ownerLocation,
    required this.createdAt,
  });

  factory CreativeModel.fromJson(Map<String, dynamic> json) {
    // Generate specifications representation from dimensions, size and format
    final int w = int.tryParse(json['width']?.toString() ?? '') ?? 0;
    final int h = int.tryParse(json['height']?.toString() ?? '') ?? 0;
    final int sizeMB = int.tryParse(json['fileSizeMB']?.toString() ?? '') ?? 0;
    final String dimensionsSpec = (w > 0 && h > 0) ? '<p>Dimensions: ${w}x${h}px</p>' : '';
    final String sizeSpec = sizeMB > 0 ? '<p>File size: ${sizeMB}MB</p>' : '';
    final String formatSpec = json['format'] != null ? '<p>Format: ${json['format']}</p>' : '';
    final String typeSpec = json['type'] != null ? '<p>Type: ${json['type']}</p>' : '';
    final specs = '$dimensionsSpec$sizeSpec$formatSpec$typeSpec';

    final List<String> featureList = [];
    if (json['features'] != null) {
      featureList.addAll(List<String>.from(json['features']));
    }

    return CreativeModel(
      id: json['id']?.toString() ?? '',
      name: json['title'] ?? json['name'] ?? '',
      image: json['thumbnail'] ?? json['image'] ?? '',
      rating: double.tryParse((json['averageRating'] ?? json['rating'] ?? 0).toString()) ?? 0.0,
      favorites: int.tryParse((json['totalLikes'] ?? json['favorites'] ?? 0).toString()) ?? 0,
      price: double.tryParse((json['price'] ?? 0).toString()) ?? 0.0,
      discount: double.tryParse((json['discount'] ?? 0).toString()) ?? 0.0,
      ordersCount: int.tryParse((json['downloads'] ?? json['ordersCount'] ?? 0).toString()) ?? 0,
      description: json['description'] ?? '',
      features: featureList,
      specifications: specs,
      isActive: json['status'] == 'ACTIVE' || (json['isActive'] ?? true),
      type: json['type'] ?? '',
      format: json['format'] ?? '',
      fileFormat: json['fileFormat'],
      category: json['category']?.toString() ?? json['type']?.toString(),
      fileSizeMB: sizeMB,
      durationInSeconds: int.tryParse(json['durationInSeconds']?.toString() ?? '') ?? 0,
      width: w,
      height: h,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      ownerName: json['createdBy']?['name']?.toString() ?? 'Brantro Africa',
      ownerBadge: json['createdBy']?['role']?.toString() ?? 'CREATOR',
      ownerEmail: json['createdBy']?['emailAddress']?.toString() ?? 'creators@brantro.com',
      ownerPhone: json['createdBy']?['phoneNumber']?.toString() ?? '08000000000',
      ownerAddress: json['createdBy']?['address']?.toString() ?? 'Syril Ihesaba Court, Gwarinpa',
      ownerLocation: json['createdBy']?['address']?.toString() ?? 'Syril Ihesaba Court, Gwarinpa, Abuja, FCT, Nigeria',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'rating': rating,
      'favorites': favorites,
      'price': price,
      'discount': discount,
      'ordersCount': ordersCount,
      'description': description,
      'features': features,
      'specifications': specifications,
      'isActive': isActive,
      'type': type,
      'format': format,
      'fileFormat': fileFormat,
      'fileSizeMB': fileSizeMB,
      'durationInSeconds': durationInSeconds,
      'width': width,
      'height': height,
      'tags': tags,
      'ownerName': ownerName,
      'ownerBadge': ownerBadge,
      'ownerEmail': ownerEmail,
      'ownerPhone': ownerPhone,
      'ownerAddress': ownerAddress,
      'ownerLocation': ownerLocation,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

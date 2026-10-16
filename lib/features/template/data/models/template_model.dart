class TemplateModel {
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
  final String ownerName;
  final String ownerBadge;
  final String ownerEmail;
  final String ownerPhone;
  final String ownerAddress;
  final String ownerLocation;
  final String? category;
  final String createdAt;

  TemplateModel({
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
    this.category,
    required this.ownerName,
    required this.ownerBadge,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.ownerAddress,
    required this.ownerLocation,
    this.createdAt = '',
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id']?.toString() ?? '',
      name: json['title'] ?? json['name'] ?? '',
      image: json['thumbnail'] ?? json['image'] ?? '',
      rating: double.tryParse((json['averageRating'] ?? json['rating'] ?? 0).toString()) ?? 0.0,
      favorites: int.tryParse((json['totalLikes'] ?? json['favorites'] ?? 0).toString()) ?? 0,
      price: double.tryParse((json['price'] ?? 0).toString()) ?? 0.0,
      discount: double.tryParse((json['discount'] ?? 0).toString()) ?? 0.0,
      ordersCount: int.tryParse((json['downloads'] ?? json['ordersCount'] ?? 0).toString()) ?? 0,
      description: json['description'] ?? '',
      features: json['features'] != null ? List<String>.from(json['features']) : [],
      specifications: json['specifications'] ?? '',
      isActive: json['status'] == 'ACTIVE' || (json['isActive'] ?? true),
      category: json['category']?.toString(),
      ownerName: json['createdBy']?['name']?.toString() ?? json['ownerName'] ?? 'Brantro Africa',
      ownerBadge: json['createdBy']?['role']?.toString() ?? json['ownerBadge'] ?? 'SUPER_ADMIN',
      ownerEmail: json['createdBy']?['emailAddress']?.toString() ?? json['ownerEmail'] ?? 'superadmin@brantro.com',
      ownerPhone: json['createdBy']?['phoneNumber']?.toString() ?? json['ownerPhone'] ?? '08000000000',
      ownerAddress: json['createdBy']?['address']?.toString() ?? json['ownerAddress'] ?? 'Syril Ihesaba Court, Gwarinpa',
      ownerLocation: json['createdBy']?['address']?.toString() ?? json['ownerLocation'] ?? 'Syril Ihesaba Court, Gwarinpa, Abuja, FCT, Nigeria',
      createdAt: json['createdAt']?.toString() ?? '',
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
      'ownerName': ownerName,
      'ownerBadge': ownerBadge,
      'ownerEmail': ownerEmail,
      'ownerPhone': ownerPhone,
      'ownerAddress': ownerAddress,
      'ownerLocation': ownerLocation,
      'createdAt': createdAt,
    };
  }
}

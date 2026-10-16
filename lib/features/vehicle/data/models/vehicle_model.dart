class VehicleModel {
  final String id;
  final String name;
  final String location;
  final String address;
  final String size;
  final String type;
  final double price;
  final String status;
  final String thumbnail;
  final List<String> images;
  final String description;
  final String featuresText;
  final String specifications;
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerEmail;
  final String? ownerAddress;
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int? estimatedReach;
  final double? averageRating;
  final int? totalLikes;
  final int? totalAdSlots;
  final String? rateUnit;
  final List<dynamic>? blockedDates;

  VehicleModel({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.size,
    required this.type,
    required this.price,
    required this.status,
    required this.thumbnail,
    required this.images,
    required this.description,
    required this.featuresText,
    required this.specifications,
    this.ownerName,
    this.ownerPhone,
    this.ownerEmail,
    this.ownerAddress,
    this.latitude,
    this.longitude,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.estimatedReach,
    this.averageRating,
    this.totalLikes,
    this.totalAdSlots,
    this.rateUnit,
    this.blockedDates,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id']?.toString() ?? '',
      name: json['title']?.toString() ?? json['name']?.toString() ?? '',
      location: json['state']?.toString() ?? json['location']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      size: json['specifications']?.toString() ?? json['size']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      price: double.tryParse((json['rate'] ?? json['price'] ?? 0).toString()) ?? 0.0,
      status: json['status']?.toString() ?? 'available',
      thumbnail: json['thumbnail']?.toString() ?? '',
      images: json['gallery'] != null ? List<String>.from(json['gallery']) : [],
      description: json['description']?.toString() ?? '',
      featuresText: json['features']?.toString() ?? '',
      specifications: json['specifications']?.toString() ?? '',
      ownerName: json['owner']?['name']?.toString(),
      ownerPhone: json['owner']?['phoneNumber']?.toString(),
      ownerEmail: json['owner']?['emailAddress']?.toString(),
      ownerAddress: json['owner']?['address']?.toString(),
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      isActive: json['isActive'] is bool ? json['isActive'] : (json['status'] == 'ACTIVE'),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
      estimatedReach: json['estimatedReach'] != null ? int.tryParse(json['estimatedReach'].toString()) : null,
      averageRating: json['averageRating'] != null ? double.tryParse(json['averageRating'].toString()) : null,
      totalLikes: json['totalLikes'] != null ? int.tryParse(json['totalLikes'].toString()) : null,
      totalAdSlots: json['totalAdSlots'] != null ? int.tryParse(json['totalAdSlots'].toString()) : null,
      rateUnit: json['rateUnit']?.toString(),
      blockedDates: json['blockedDates'] != null && json['blockedDates'] is List ? json['blockedDates'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'address': address,
      'size': size,
      'type': type,
      'price': price,
      'status': status,
      'thumbnail': thumbnail,
      'images': images,
      'description': description,
      'featuresText': featuresText,
      'specifications': specifications,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'ownerAddress': ownerAddress,
      'latitude': latitude,
      'longitude': longitude,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'estimatedReach': estimatedReach,
      'averageRating': averageRating,
      'totalLikes': totalLikes,
      'totalAdSlots': totalAdSlots,
    };
  }
}

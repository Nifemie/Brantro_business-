class ScreenModel {
  final String id;
  final String name;
  final String location;
  final String address;
  final String size;
  final String type;
  final double price;
  final String status;
  final List<String> images;
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ScreenModel({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.size,
    required this.type,
    required this.price,
    required this.status,
    required this.images,
    this.latitude,
    this.longitude,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory ScreenModel.fromJson(Map<String, dynamic> json) {
    return ScreenModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      address: json['address'] ?? '',
      size: json['size'] ?? '',
      type: json['type'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? 'available',
      images: List<String>.from(json['images'] ?? []),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
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
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

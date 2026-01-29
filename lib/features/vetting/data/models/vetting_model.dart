class VettingOptionModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final int durationHours;
  final String? note;
  final String status; // e.g., 'ACTIVE', 'INACTIVE'
  final DateTime createdAt;
  final DateTime updatedAt;

  VettingOptionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.durationHours,
    this.note,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VettingOptionModel.fromJson(Map<String, dynamic> json) {
    return VettingOptionModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      durationHours: json['durationHours'] ?? 0,
      note: json['note'],
      status: json['status'] ?? 'ACTIVE',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price.toString(),
      'durationHours': durationHours,
      'note': note,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Computed properties
  String get formattedPrice => '₦${price.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  )}';

  String get durationDisplay {
    if (durationHours < 24) {
      return '$durationHours hrs';
    } else {
      final days = (durationHours / 24).round();
      return '$durationHours hrs (~$days days)';
    }
  }

  bool get isActive => status.toUpperCase() == 'ACTIVE';
}

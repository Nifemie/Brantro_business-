class AdSlotModel {
  final String id;
  final String parentId; // billboard/wall/screen ID
  final String parentType; // 'billboard', 'wall', 'screen'
  final String slotNumber;
  final int duration; // in days
  final double price;
  final String status; // 'available', 'booked', 'occupied'
  final DateTime? startDate;
  final DateTime? endDate;
  final String? bookedBy;
  final int? maxRevisions; // Maximum number of revisions allowed
  final String? audience; // Expected audience/impressions (e.g., "100k - 500k")
  final DateTime createdAt;

  AdSlotModel({
    required this.id,
    required this.parentId,
    required this.parentType,
    required this.slotNumber,
    required this.duration,
    required this.price,
    required this.status,
    this.startDate,
    this.endDate,
    this.bookedBy,
    this.maxRevisions,
    this.audience,
    required this.createdAt,
  });

  factory AdSlotModel.fromJson(Map<String, dynamic> json) {
    return AdSlotModel(
      id: json['id'] ?? '',
      parentId: json['parentId'] ?? '',
      parentType: json['parentType'] ?? '',
      slotNumber: json['slotNumber'] ?? '',
      duration: json['duration'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? 'available',
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      bookedBy: json['bookedBy'],
      maxRevisions: json['maxRevisions'],
      audience: json['audience'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'parentType': parentType,
      'slotNumber': slotNumber,
      'duration': duration,
      'price': price,
      'status': status,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'bookedBy': bookedBy,
      'maxRevisions': maxRevisions,
      'audience': audience,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AdSlotModel copyWith({
    String? id,
    String? parentId,
    String? parentType,
    String? slotNumber,
    int? duration,
    double? price,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String? bookedBy,
    int? maxRevisions,
    String? audience,
    DateTime? createdAt,
  }) {
    return AdSlotModel(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      parentType: parentType ?? this.parentType,
      slotNumber: slotNumber ?? this.slotNumber,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      bookedBy: bookedBy ?? this.bookedBy,
      maxRevisions: maxRevisions ?? this.maxRevisions,
      audience: audience ?? this.audience,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

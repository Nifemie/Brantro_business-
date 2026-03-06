class AdSlotModel {
  final String id;
  final String billboardId;
  final String slotNumber;
  final int duration; // in days
  final double price;
  final String status; // available, booked, maintenance
  final DateTime? bookedFrom;
  final DateTime? bookedTo;
  final String? orderId;
  final DateTime createdAt;

  AdSlotModel({
    required this.id,
    required this.billboardId,
    required this.slotNumber,
    required this.duration,
    required this.price,
    required this.status,
    this.bookedFrom,
    this.bookedTo,
    this.orderId,
    required this.createdAt,
  });

  factory AdSlotModel.fromJson(Map<String, dynamic> json) {
    return AdSlotModel(
      id: json['id'] ?? '',
      billboardId: json['billboardId'] ?? '',
      slotNumber: json['slotNumber'] ?? '',
      duration: json['duration'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? 'available',
      bookedFrom: json['bookedFrom'] != null 
          ? DateTime.parse(json['bookedFrom']) 
          : null,
      bookedTo: json['bookedTo'] != null 
          ? DateTime.parse(json['bookedTo']) 
          : null,
      orderId: json['orderId'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'billboardId': billboardId,
      'slotNumber': slotNumber,
      'duration': duration,
      'price': price,
      'status': status,
      'bookedFrom': bookedFrom?.toIso8601String(),
      'bookedTo': bookedTo?.toIso8601String(),
      'orderId': orderId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isAvailable => status == 'available';
  bool get isBooked => status == 'booked';
}

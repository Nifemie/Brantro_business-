class OrderModel {
  final String id;
  final String serviceType; // 'billboard', 'screen', 'wall', 'template', 'creative', 'service', 'vetting'
  final String serviceName;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final double amount;
  final String status; // 'pending', 'active', 'completed', 'cancelled'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? description;
  final Map<String, dynamic>? metadata;

  OrderModel({
    required this.id,
    required this.serviceType,
    required this.serviceName,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.description,
    this.metadata,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      serviceType: json['serviceType'] as String,
      serviceName: json['serviceName'] as String,
      customerName: json['customerName'] as String,
      customerEmail: json['customerEmail'] as String,
      customerPhone: json['customerPhone'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceType': serviceType,
      'serviceName': serviceName,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'amount': amount,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'description': description,
      'metadata': metadata,
    };
  }

  OrderModel copyWith({
    String? id,
    String? serviceType,
    String? serviceName,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    double? amount,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    Map<String, dynamic>? metadata,
  }) {
    return OrderModel(
      id: id ?? this.id,
      serviceType: serviceType ?? this.serviceType,
      serviceName: serviceName ?? this.serviceName,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
    );
  }
}

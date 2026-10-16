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
  final String? imageUrl;
  final int itemsCount;
  final double creatorRating;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? requirementsProvided;
  final String? itemStatus;
  final Map<String, dynamic>? itemStatusReason;

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
    this.imageUrl,
    this.itemsCount = 1,
    this.creatorRating = 0.0,
    this.metadata,
    this.requirementsProvided,
    this.itemStatus,
    this.itemStatusReason,
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
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      itemsCount: json['itemsCount'] as int? ?? 1,
      creatorRating: (json['creatorRating'] as num?)?.toDouble() ?? 0.0,
      metadata: json['metadata'] as Map<String, dynamic>?,
      requirementsProvided: json['requirementsProvided'] as Map<String, dynamic>?,
      itemStatus: json['itemStatus'] as String?,
      itemStatusReason: json['itemStatusReason'] as Map<String, dynamic>?,
    );
  }

  factory OrderModel.fromCreativeOrderJson(Map<String, dynamic> json) {
    // A creative order payload might have a list of creatives. We'll extract info from the first one.
    final creatives = json['creatives'] as List<dynamic>? ?? [];
    final firstCreative = creatives.isNotEmpty ? creatives.first : {};

    final creator = json['creator'] ?? {};
    final user = json['user'] ?? {};

    return OrderModel(
      id: json['paymentRef']?.toString() ?? json['id']?.toString() ?? '',
      serviceType: 'creative',
      serviceName: firstCreative['title']?.toString() ?? 'Creative Order',
      customerName: user['name']?.toString() ?? creator['name']?.toString() ?? 'Customer',
      customerEmail: user['emailAddress']?.toString() ?? creator['emailAddress']?.toString() ?? '',
      customerPhone: user['phoneNumber']?.toString() ?? creator['phoneNumber']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? 'UNKNOWN',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      description: json['remark']?.toString(),
      imageUrl: firstCreative['thumbnail']?.toString(),
      itemsCount: creatives.isEmpty ? 1 : creatives.length,
      creatorRating:
          double.tryParse(user['averageRating']?.toString() ?? creator['averageRating']?.toString() ?? '0') ?? 0.0,
      metadata: json, // Store the full response just in case
    );
  }

  factory OrderModel.fromTemplateOrderJson(Map<String, dynamic> json) {
    final templates = json['templates'] as List<dynamic>? ?? [];
    final firstTemplate = templates.isNotEmpty ? templates.first : {};

    final creator = json['creator'] ?? {};
    final user = json['user'] ?? {};

    return OrderModel(
      id: json['paymentRef']?.toString() ?? json['id']?.toString() ?? '',
      serviceType: 'template',
      serviceName: firstTemplate['title']?.toString() ?? 'Template Order',
      customerName: user['name']?.toString() ?? creator['name']?.toString() ?? 'Customer',
      customerEmail: user['emailAddress']?.toString() ?? creator['emailAddress']?.toString() ?? '',
      customerPhone: user['phoneNumber']?.toString() ?? creator['phoneNumber']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? 'UNKNOWN',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      description: json['remark']?.toString(),
      imageUrl: firstTemplate['thumbnail']?.toString(),
      itemsCount: templates.isEmpty ? 1 : templates.length,
      creatorRating:
          double.tryParse(user['averageRating']?.toString() ?? creator['averageRating']?.toString() ?? '0') ?? 0.0,
      metadata: json,
    );
  }

  factory OrderModel.fromServiceOrderJson(Map<String, dynamic> json) {
    final items = json['items'] as List<dynamic>? ?? [];
    final firstItem = items.isNotEmpty ? items.first : {};
    final service = firstItem['service'] ?? {};

    final provider = json['provider'] ?? {};
    final user = json['user'] ?? {};

    return OrderModel(
      id: json['paymentRef']?.toString() ?? json['id']?.toString() ?? '',
      serviceType: 'service',
      serviceName: service['title']?.toString() ?? 'Service Order',
      customerName: user['name']?.toString() ?? provider['name']?.toString() ?? 'Customer',
      customerEmail: user['emailAddress']?.toString() ?? provider['emailAddress']?.toString() ?? '',
      customerPhone: user['phoneNumber']?.toString() ?? provider['phoneNumber']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? 'UNKNOWN',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      description:
          json['remark']?.toString() ??
          firstItem['requirementsProvided']?['description']?.toString(),
      imageUrl: service['thumbnail']?.toString(),
      itemsCount: items.isEmpty ? 1 : items.length,
      creatorRating:
          double.tryParse(provider['averageRating']?.toString() ?? '0') ?? 0.0,
      metadata: json,
      requirementsProvided:
          firstItem['requirementsProvided'] as Map<String, dynamic>?,
      itemStatus: firstItem['status']?.toString(),
      itemStatusReason: firstItem['statusReason'] as Map<String, dynamic>?,
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
      'itemsCount': itemsCount,
      'creatorRating': creatorRating,
      'metadata': metadata,
      'requirementsProvided': requirementsProvided,
      'itemStatus': itemStatus,
      'itemStatusReason': itemStatusReason,
    };
  }

  String get effectiveStatus {
    if (serviceType.toLowerCase() == 'service' &&
        metadata != null &&
        metadata!.containsKey('items')) {
      final items = metadata!['items'] as List<dynamic>? ?? [];
      if (items.isNotEmpty) {
        final itemStatusCheck = items.first['status']?.toString().toLowerCase();
        if (itemStatusCheck != null) {
          if (itemStatusCheck == 'pending') return 'pending';
          if (itemStatusCheck == 'inprogress' ||
              itemStatusCheck == 'in_progress' ||
              itemStatusCheck == 'accepted')
            return 'in_progress';
          if (itemStatusCheck == 'delivered') return 'delivered';
          if (itemStatusCheck == 'completed' || itemStatusCheck == 'approved')
            return 'completed';
          if (itemStatusCheck == 'failed' ||
              itemStatusCheck == 'cancelled' ||
              itemStatusCheck == 'rejected')
            return 'failed';
        }
      }
    }

    final baseStatus = status.toLowerCase();
    if (baseStatus == 'paid')
      return 'pending'; // A paid order is pending work by default
    return baseStatus;
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
    int? itemsCount,
    double? creatorRating,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? requirementsProvided,
    String? itemStatus,
    Map<String, dynamic>? itemStatusReason,
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
      itemsCount: itemsCount ?? this.itemsCount,
      creatorRating: creatorRating ?? this.creatorRating,
      metadata: metadata ?? this.metadata,
      requirementsProvided: requirementsProvided ?? this.requirementsProvided,
      itemStatus: itemStatus ?? this.itemStatus,
      itemStatusReason: itemStatusReason ?? this.itemStatusReason,
    );
  }
}

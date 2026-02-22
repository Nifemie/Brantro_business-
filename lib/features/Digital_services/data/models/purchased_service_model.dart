import 'service_model.dart';

class PurchasedServicesResponse {
  final bool success;
  final String message;
  final PurchasedServicesPayload? payload;

  PurchasedServicesResponse({
    required this.success,
    required this.message,
    this.payload,
  });

  factory PurchasedServicesResponse.fromJson(Map<String, dynamic> json) {
    return PurchasedServicesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      payload: json['payload'] != null
          ? PurchasedServicesPayload.fromJson(json['payload'])
          : null,
    );
  }
}

class PurchasedServicesPayload {
  final List<ServiceOrderModel> page;
  final String size;
  final int currentPage;
  final int totalPages;

  PurchasedServicesPayload({
    required this.page,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory PurchasedServicesPayload.fromJson(Map<String, dynamic> json) {
    return PurchasedServicesPayload(
      page: (json['page'] as List?)
              ?.map((e) => ServiceOrderModel.fromJson(e))
              .toList() ??
          [],
      size: json['size']?.toString() ?? '10',
      currentPage: json['currentPage'] is String 
          ? int.tryParse(json['currentPage']) ?? 0 
          : json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  bool get isDataAvailable => page.isNotEmpty;
}

class ServiceOrderModel {
  final int id;
  final int userId;
  final int creatorId;
  final String amount;
  final String method;
  final String currency;
  final String paymentRef;
  final DateTime? paidAt;
  final String groupRef;
  final String status;
  final ChargeBreakdown? chargeBreakdown;
  final bool settled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserInfo? user;
  final UserInfo? creator;
  final List<ServiceItemModel> items;

  ServiceOrderModel({
    required this.id,
    required this.userId,
    required this.creatorId,
    required this.amount,
    required this.method,
    required this.currency,
    required this.paymentRef,
    this.paidAt,
    required this.groupRef,
    required this.status,
    this.chargeBreakdown,
    required this.settled,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.creator,
    required this.items,
  });

  factory ServiceOrderModel.fromJson(Map<String, dynamic> json) {
    return ServiceOrderModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      creatorId: json['creatorId'] as int,
      amount: json['amount']?.toString() ?? '0',
      method: json['method'] as String,
      currency: json['currency'] as String,
      paymentRef: json['paymentRef'] as String,
      paidAt: json['paidAt'] != null
          ? DateTime.tryParse(json['paidAt'])
          : null,
      groupRef: json['groupRef'] as String,
      status: json['status'] as String,
      chargeBreakdown: json['chargeBreakdown'] != null
          ? ChargeBreakdown.fromJson(json['chargeBreakdown'])
          : null,
      settled: json['settled'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
      creator: json['creator'] != null ? UserInfo.fromJson(json['creator']) : null,
      items: (json['items'] as List?)
              ?.map((e) => ServiceItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  String get formattedAmount {
    final amountValue = double.tryParse(amount) ?? 0;
    return '₦${amountValue.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  String get formattedTotalPayable {
    if (chargeBreakdown != null) {
      return '₦${chargeBreakdown!.totalPayable.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}';
    }
    return formattedAmount;
  }
  
  bool get isCompleted => status == 'COMPLETED' || status == 'PAID';
  bool get isPending => status == 'PENDING';
  bool get isInProgress => status == 'IN_PROGRESS';
}

class ServiceItemModel {
  final int id;
  final int orderId;
  final int serviceId;
  final String status;
  final ChargeBreakdown? chargeBreakdown;
  final dynamic requirementsProvided;
  final List<dynamic> requirementsProvidedHistory;
  final String? providerRemark;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final int? approvedById;
  final DateTime? approvedAt;
  final DateTime? completedAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<dynamic> updateHistory;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ServiceModel? service;
  final List<dynamic> deliveries;

  ServiceItemModel({
    required this.id,
    required this.orderId,
    required this.serviceId,
    required this.status,
    this.chargeBreakdown,
    this.requirementsProvided,
    required this.requirementsProvidedHistory,
    this.providerRemark,
    this.acceptedAt,
    this.rejectedAt,
    this.approvedById,
    this.approvedAt,
    this.completedAt,
    this.startDate,
    this.endDate,
    required this.updateHistory,
    required this.createdAt,
    required this.updatedAt,
    this.service,
    required this.deliveries,
  });

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) {
    return ServiceItemModel(
      id: json['id'] as int,
      orderId: json['orderId'] as int,
      serviceId: json['serviceId'] as int,
      status: json['status'] as String,
      chargeBreakdown: json['chargeBreakdown'] != null
          ? ChargeBreakdown.fromJson(json['chargeBreakdown'])
          : null,
      requirementsProvided: json['requirementsProvided'],
      requirementsProvidedHistory: json['requirementsProvidedHistory'] as List? ?? [],
      providerRemark: json['providerRemark'],
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.tryParse(json['acceptedAt'])
          : null,
      rejectedAt: json['rejectedAt'] != null
          ? DateTime.tryParse(json['rejectedAt'])
          : null,
      approvedById: json['approvedById'],
      approvedAt: json['approvedAt'] != null
          ? DateTime.tryParse(json['approvedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
      updateHistory: json['updateHistory'] as List? ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      service: json['service'] != null
          ? ServiceModel.fromJson(json['service'])
          : null,
      deliveries: json['deliveries'] as List? ?? [],
    );
  }

  bool get isCompleted => status == 'COMPLETED';
  bool get isPending => status == 'PENDING';
  bool get isInProgress => status == 'IN_PROGRESS' || status == 'ACCEPTED';
  bool get isRejected => status == 'REJECTED';
  bool get isCancelled => status == 'CANCELLED';
  
  bool get needsRequirements => requirementsProvided == null && isPending;
  bool get hasDeliveries => deliveries.isNotEmpty;
  
  // Getter to access project details from requirementsProvided
  Map<String, dynamic>? get projectDetails {
    if (requirementsProvided == null) return null;
    if (requirementsProvided is Map<String, dynamic>) {
      return requirementsProvided as Map<String, dynamic>;
    }
    return null;
  }
}

class ChargeBreakdown {
  final double subtotal;
  final double vatAmount;
  final double platformFee;
  final double totalPayable;
  final double serviceCharge;
  final double sellerNetAmount;

  ChargeBreakdown({
    required this.subtotal,
    required this.vatAmount,
    required this.platformFee,
    required this.totalPayable,
    required this.serviceCharge,
    required this.sellerNetAmount,
  });

  factory ChargeBreakdown.fromJson(Map<String, dynamic> json) {
    return ChargeBreakdown(
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      vatAmount: (json['vatAmount'] as num?)?.toDouble() ?? 0.0,
      platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
      totalPayable: (json['totalPayable'] as num?)?.toDouble() ?? 0.0,
      serviceCharge: (json['serviceCharge'] as num?)?.toDouble() ?? 0.0,
      sellerNetAmount: (json['sellerNetAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class UserInfo {
  final int id;
  final String name;
  final String? emailAddress;
  final String? avatarUrl;

  UserInfo({
    required this.id,
    required this.name,
    this.emailAddress,
    this.avatarUrl,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      emailAddress: json['emailAddress'],
      avatarUrl: json['avatarUrl'],
    );
  }
}

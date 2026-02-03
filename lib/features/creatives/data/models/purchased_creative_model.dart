import 'creative_model.dart';

class PurchasedCreativesResponse {
  final bool success;
  final String message;
  final PurchasedCreativesPayload? payload;

  PurchasedCreativesResponse({
    required this.success,
    required this.message,
    this.payload,
  });

  factory PurchasedCreativesResponse.fromJson(Map<String, dynamic> json) {
    return PurchasedCreativesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      payload: json['payload'] != null
          ? PurchasedCreativesPayload.fromJson(json['payload'])
          : null,
    );
  }
}

class PurchasedCreativesPayload {
  final List<CreativeOrderModel> page;
  final String size;
  final int currentPage;
  final int totalPages;

  PurchasedCreativesPayload({
    required this.page,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory PurchasedCreativesPayload.fromJson(Map<String, dynamic> json) {
    return PurchasedCreativesPayload(
      page: (json['page'] as List?)
              ?.map((e) => CreativeOrderModel.fromJson(e))
              .toList() ??
          [],
      size: json['size']?.toString() ?? '10',
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

class CreativeOrderModel {
  final int id;
  final int userId;
  final int creatorId;
  final String amount;
  final String method;
  final String currency;
  final String paymentRef;
  final String groupRef;
  final String status;
  final String remark;
  final ChargeBreakdown? chargeBreakdown;
  final bool settled;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CreativeModel> creatives;

  CreativeOrderModel({
    required this.id,
    required this.userId,
    required this.creatorId,
    required this.amount,
    required this.method,
    required this.currency,
    required this.paymentRef,
    required this.groupRef,
    required this.status,
    required this.remark,
    this.chargeBreakdown,
    required this.settled,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.creatives,
  });

  factory CreativeOrderModel.fromJson(Map<String, dynamic> json) {
    return CreativeOrderModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      creatorId: json['creatorId'] as int,
      amount: json['amount']?.toString() ?? '0',
      method: json['method'] as String,
      currency: json['currency'] as String,
      paymentRef: json['paymentRef'] as String,
      groupRef: json['groupRef'] as String,
      status: json['status'] as String,
      remark: json['remark'] as String? ?? '',
      chargeBreakdown: json['chargeBreakdown'] != null
          ? ChargeBreakdown.fromJson(json['chargeBreakdown'])
          : null,
      settled: json['settled'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      creatives: (json['creatives'] as List?)
              ?.map((e) => CreativeModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  String get formattedAmount => '₦${double.parse(amount).toStringAsFixed(2)}';
  
  bool get isCompleted => status == 'COMPLETED';
  bool get isPending => status == 'PENDING';
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

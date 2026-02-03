import 'template_model.dart';

class PurchasedTemplatesResponse {
  final bool success;
  final String message;
  final PurchasedTemplatesPayload? payload;

  PurchasedTemplatesResponse({
    required this.success,
    required this.message,
    this.payload,
  });

  factory PurchasedTemplatesResponse.fromJson(Map<String, dynamic> json) {
    return PurchasedTemplatesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      payload: json['payload'] != null
          ? PurchasedTemplatesPayload.fromJson(json['payload'])
          : null,
    );
  }
}

class PurchasedTemplatesPayload {
  final List<TemplateOrderModel> page;
  final String size;
  final int currentPage;
  final int totalPages;

  PurchasedTemplatesPayload({
    required this.page,
    required this.size,
    required this.currentPage,
    required this.totalPages,
  });

  factory PurchasedTemplatesPayload.fromJson(Map<String, dynamic> json) {
    return PurchasedTemplatesPayload(
      page: (json['page'] as List?)
              ?.map((e) => TemplateOrderModel.fromJson(e))
              .toList() ??
          [],
      size: json['size']?.toString() ?? '10',
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

class TemplateOrderModel {
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
  final List<TemplateModel> templates;

  TemplateOrderModel({
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
    required this.templates,
  });

  factory TemplateOrderModel.fromJson(Map<String, dynamic> json) {
    return TemplateOrderModel(
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
      templates: (json['templates'] as List?)
              ?.map((e) => TemplateModel.fromJson(e))
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

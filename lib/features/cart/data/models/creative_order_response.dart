class CreativeOrderResponse {
  final bool success;
  final String message;
  final CreativeOrderData? data;

  CreativeOrderResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CreativeOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreativeOrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? CreativeOrderData.fromJson(json['data']) : null,
    );
  }
}

class CreativeOrderData {
  final String orderId;
  final String reference;
  final String status;
  final double amount;
  final String currency;
  final String paymentMethod;
  final DateTime? createdAt;

  CreativeOrderData({
    required this.orderId,
    required this.reference,
    required this.status,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    this.createdAt,
  });

  factory CreativeOrderData.fromJson(Map<String, dynamic> json) {
    return CreativeOrderData(
      orderId: json['orderId']?.toString() ?? json['id']?.toString() ?? '',
      reference: json['reference'] ?? '',
      status: json['status'] ?? 'PENDING',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'NGN',
      paymentMethod: json['paymentMethod'] ?? json['method'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) 
          : null,
    );
  }
}

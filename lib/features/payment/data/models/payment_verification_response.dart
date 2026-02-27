class PaymentVerificationResponse {
  final String reference;
  final String status;
  final double amount;
  final String currency;
  final String paidAt;
  final String channel;

  PaymentVerificationResponse({
    required this.reference,
    required this.status,
    required this.amount,
    required this.currency,
    required this.paidAt,
    required this.channel,
  });

  factory PaymentVerificationResponse.fromJson(Map<String, dynamic> json) {
    return PaymentVerificationResponse(
      reference: json['reference'] ?? '',
      status: json['status'] ?? '',
      amount: (json['amount'] is int) 
          ? (json['amount'] as int).toDouble() 
          : (json['amount'] ?? 0.0),
      currency: json['currency'] ?? 'NGN',
      paidAt: json['paid_at'] ?? json['paidAt'] ?? '',
      channel: json['channel'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'status': status,
      'amount': amount,
      'currency': currency,
      'paidAt': paidAt,
      'channel': channel,
    };
  }

  bool get isSuccessful => status.toLowerCase() == 'success';
}

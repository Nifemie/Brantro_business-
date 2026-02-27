class PaymentRequest {
  final String email;
  final double amount; // Amount in Naira (will be converted to kobo)
  final String reference;
  final String currency;
  final Map<String, dynamic> metadata;
  final String? callbackUrl;
  final List<String>? channels;

  PaymentRequest({
    required this.email,
    required this.amount,
    required this.reference,
    this.currency = 'NGN',
    required this.metadata,
    this.callbackUrl,
    this.channels,
  });

  /// Create payment request with required metadata structure
  /// 
  /// Required metadata fields:
  /// - userId: User ID from session
  /// - purpose: Payment purpose (campaign_payment, creative_purchase, etc.)
  /// - reference: Payment reference
  /// - email: User email
  /// - amount: Total amount in Naira
  factory PaymentRequest.create({
    required String email,
    required int userId,
    required String purpose,
    required double totalAmount,
    required String reference,
    Map<String, dynamic>? additionalData,
    List<String>? channels,
  }) {
    return PaymentRequest(
      email: email,
      amount: totalAmount,
      reference: reference,
      metadata: {
        'userId': userId,
        'purpose': purpose,
        'reference': reference,
        'email': email,
        'amount': totalAmount,
        ...?additionalData, // Spread any additional metadata
      },
      channels: channels ?? ['card', 'bank', 'ussd', 'qr', 'mobile_money', 'bank_transfer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'amount': (amount * 100).toInt(), // Convert Naira to kobo
      'reference': reference,
      'currency': currency,
      'metadata': metadata,
      if (callbackUrl != null) 'callback_url': callbackUrl,
      if (channels != null) 'channels': channels,
    };
  }

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      email: json['email'] as String,
      amount: (json['amount'] as num).toDouble() / 100, // Convert kobo to Naira
      reference: json['reference'] as String,
      currency: json['currency'] as String? ?? 'NGN',
      metadata: json['metadata'] as Map<String, dynamic>,
      callbackUrl: json['callback_url'] as String?,
      channels: (json['channels'] as List<dynamic>?)?.cast<String>(),
    );
  }
}

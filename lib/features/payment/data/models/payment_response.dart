class PaymentResponse {
  final bool status;
  final String message;
  final PaymentData? data;

  PaymentResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? PaymentData.fromJson(json['data']) : null,
    );
  }
}

class PaymentData {
  final String authorizationUrl;
  final String accessCode;
  final String reference;

  PaymentData({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      authorizationUrl: json['authorization_url'] ?? '',
      accessCode: json['access_code'] ?? '',
      reference: json['reference'] ?? '',
    );
  }
}

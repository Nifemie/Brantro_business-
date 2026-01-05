class VerifyOtpRequest {
  final String identity;
  final String otp;

  VerifyOtpRequest({
    required this.identity,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'identity': identity,
      'otp': otp,
    };
  }
}

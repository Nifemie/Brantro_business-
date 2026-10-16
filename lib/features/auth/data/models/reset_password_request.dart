/// Request model for reset password endpoint
class ResetPasswordRequest {
  final String identity; // email or phone
  final String newPassword;
  final String? otp;

  ResetPasswordRequest({
    required this.identity,
    required this.newPassword,
    this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'identity': identity,
      'newPassword': newPassword,
      if (otp != null && otp!.isNotEmpty) 'otp': otp,
    };
  }
}

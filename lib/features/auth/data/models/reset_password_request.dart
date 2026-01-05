/// Request model for reset password endpoint
class ResetPasswordRequest {
  final String identity; // email or phone
  final String newPassword;

  ResetPasswordRequest({required this.identity, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {'identity': identity, 'newPassword': newPassword};
  }
}

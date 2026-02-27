/// Request model for forgot password endpoint
/// Sends identity (email or phone) to trigger OTP
class ForgotPasswordRequest {
  final String identity;

  ForgotPasswordRequest({required this.identity}) {
    if (!_isValidIdentity(identity)) {
      throw ArgumentError(
        'Identity must be a valid email address or phone number',
      );
    }
  }

  /// Validates if the identity is either a valid email or phone number
  static bool _isValidIdentity(String identity) {
    if (identity.isEmpty) return false;

    // Check if it's a valid email
    if (_isValidEmail(identity)) return true;

    // Check if it's a valid phone number (basic validation)
    if (_isValidPhone(identity)) return true;

    return false;
  }

  /// Simple email validation
  static bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Simple phone validation (allows digits, +, -, spaces)
  static bool _isValidPhone(String phone) {
    // Remove common formatting characters
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)\.+]'), '');
    // Must be numeric and between 7-15 digits (ITU standard)
    return RegExp(r'^\d{7,15}$').hasMatch(cleaned);
  }

  Map<String, dynamic> toJson() {
    return {'identity': identity};
  }
}

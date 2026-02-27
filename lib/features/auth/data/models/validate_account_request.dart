/// Request to validate user account and trigger OTP via email and/or phone
/// During signup: Both email and phone are sent (OTP sent to both channels)
/// During forgot password: Only one identity is sent (email or phone)
class ValidateAccountRequest {
  final String? email;
  final String? phoneNumber;

  ValidateAccountRequest({this.email, this.phoneNumber}) {
    // At least one must be provided
    if ((email == null || email!.isEmpty) &&
        (phoneNumber == null || phoneNumber!.isEmpty)) {
      throw ArgumentError('At least email or phone number must be provided');
    }

    // If email is provided, validate it
    if (email != null && email!.isNotEmpty) {
      if (!_isValidEmail(email!)) {
        throw ArgumentError('Email must be a valid email address');
      }
    }

    // If phone is provided, validate it
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      if (!_isValidPhone(phoneNumber!)) {
        throw ArgumentError('Phone number must be valid (7-15 digits)');
      }
    }
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
    final map = <String, dynamic>{};
    if (email != null && email!.isNotEmpty) {
      map['email'] = email;
    }
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      map['phoneNumber'] = phoneNumber;
    }
    return map;
  }
}

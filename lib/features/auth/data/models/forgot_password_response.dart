/// Response model for forgot password endpoint
class ForgotPasswordResponse {
  final bool success;
  final String message;
  final String payload; // Contains verification code sent message

  ForgotPasswordResponse({
    required this.success,
    required this.message,
    required this.payload,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      payload: _parsePayload(json['payload']),
    );
  }

  /// Safely parse payload which might be String, int, or other types
  static String _parsePayload(dynamic payload) {
    if (payload == null) return '';
    if (payload is String) return payload;
    return payload.toString();
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'payload': payload};
  }
}

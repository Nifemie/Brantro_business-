/// Response model for reset password endpoint
class ResetPasswordResponse {
  final bool success;
  final String message;
  final String? payload;

  ResetPasswordResponse({
    required this.success,
    required this.message,
    this.payload,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      payload: json['payload'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (payload != null) 'payload': payload,
    };
  }
}

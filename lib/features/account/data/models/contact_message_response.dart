class ContactMessageResponse {
  final bool success;
  final String message;

  ContactMessageResponse({
    required this.success,
    required this.message,
  });

  factory ContactMessageResponse.fromJson(Map<String, dynamic> json) {
    return ContactMessageResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'Message sent successfully',
    );
  }
}

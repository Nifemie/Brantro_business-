import 'user_model.dart';

class SignUpResponse {
  final bool success;
  final String message;
  final UserModel? user;
  final String? accessToken;

  SignUpResponse({
    required this.success,
    required this.message,
    this.user,
    this.accessToken,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: json['user'] != null || json['data'] != null
          ? UserModel.fromJson(json['user'] ?? json['data'])
          : null,
      accessToken: json['accessToken'] ?? json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (user != null) 'user': user!.toJson(),
      if (accessToken != null) 'accessToken': accessToken,
    };
  }
}

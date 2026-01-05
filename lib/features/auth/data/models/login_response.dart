import 'user_model.dart';

class LoginResponse {
  final bool success;
  final String message;
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;

  LoginResponse({
    required this.success,
    required this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    dynamic data = json['data'];
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: data != null ? UserModel.fromJson(data) : null,
      accessToken: data != null ? data['accessToken'] : null,
      refreshToken: data != null ? data['refreshToken'] : null,
      expiresIn: data != null ? data['expiresIn'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        if (user != null) ...user!.toJson(),
        if (accessToken != null) 'accessToken': accessToken,
        if (refreshToken != null) 'refreshToken': refreshToken,
        if (expiresIn != null) 'expiresIn': expiresIn,
      }
    };
  }
}

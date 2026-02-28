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
    // The actual response has a 'payload' object containing user and accessToken
    dynamic payload = json['payload'] ?? json['data'];
    
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: payload != null && payload['user'] != null 
          ? UserModel.fromJson(payload['user']) 
          : null,
      accessToken: payload != null ? payload['accessToken'] : null,
      refreshToken: payload != null ? payload['refreshToken'] : null,
      expiresIn: payload != null ? payload['expiresIn'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'payload': {
        if (user != null) 'user': user!.toJson(),
        if (accessToken != null) 'accessToken': accessToken,
        if (refreshToken != null) 'refreshToken': refreshToken,
        if (expiresIn != null) 'expiresIn': expiresIn,
      }
    };
  }
}

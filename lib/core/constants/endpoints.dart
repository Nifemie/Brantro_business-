class ApiEndpoints {
  // Base API version
  static const String apiVersion = '/api/v1';

  // Auth Endpoints
  static const String signup = '$apiVersion/user/signup';
  static const String validateAccount = '$apiVersion/user/validate-account';
  static const String verifyAccount = '$apiVersion/user/verify-account';
  static const String login = '$apiVersion/auth/login';
  static const String forgotPassword = '$apiVersion/user/forgot-password';
  static const String resetPassword = '$apiVersion/user/reset-password';

  // Creator Endpoints
  static const String usersList = '$apiVersion/user/list';
}

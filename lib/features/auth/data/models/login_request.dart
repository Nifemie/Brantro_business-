class LoginRequest {
  final String username;
  final String password;
  final String authProvider;

  LoginRequest({
    required this.username,
    required this.password,
    this.authProvider = 'INTERNAL',
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'authProvider': authProvider,
    };
  }
}

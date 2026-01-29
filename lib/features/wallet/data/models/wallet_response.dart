import 'wallet_model.dart';

class WalletResponse {
  final bool success;
  final String message;
  final WalletModel payload;

  WalletResponse({
    required this.success,
    required this.message,
    required this.payload,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      payload: WalletModel.fromJson(json['payload'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'payload': payload.toJson(),
    };
  }
}

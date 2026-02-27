import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import 'models/payment_request.dart';
import 'models/payment_response.dart';
import 'models/payment_verification_response.dart';

class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  // Initialize payment transaction
  Future<PaymentResponse?> initializePayment(PaymentRequest request) async {
    try {
      final response = await _apiClient.post(
        '/payment/initialize',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to initialize payment');
    }
  }

  // Verify payment transaction
  Future<PaymentVerificationResponse?> verifyPayment(String reference) async {
    try {
      final response = await _apiClient.get('/payment/verify/$reference');

      if (response.statusCode == 200) {
        return PaymentVerificationResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to verify payment');
    }
  }

  // Get payment status
  Future<PaymentVerificationResponse?> getPaymentStatus(String reference) async {
    try {
      final response = await _apiClient.get('/payment/status/$reference');

      if (response.statusCode == 200) {
        return PaymentVerificationResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to get payment status');
    }
  }
}

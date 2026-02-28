import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'kyc_models.dart';

class KycRepository {
  final ApiClient apiClient;

  KycRepository(this.apiClient);

  /// Get KYC status
  Future<KycStatusResponse> getKycStatus() async {
    try {
      final response = await apiClient.get(ApiEndpoints.kycStatus);
      
      // Parse response based on backend structure
      final data = response.data;
      final payload = data['payload'] ?? data['data'] ?? data;
      
      // Handle empty array response (no KYC record)
      if (payload is List && payload.isEmpty) {
        return KycStatusResponse(
          status: 'NOT_STARTED',
          message: 'KYC verification not started',
        );
      }
      
      // Handle object response
      if (payload is Map<String, dynamic>) {
        return KycStatusResponse.fromJson(payload);
      }
      
      // Default to not started
      return KycStatusResponse(
        status: 'NOT_STARTED',
        message: 'KYC verification not started',
      );
    } on DioException catch (e) {
      // Handle 404 as not started
      if (e.response?.statusCode == 404) {
        return KycStatusResponse(
          status: 'NOT_STARTED',
          message: 'KYC verification not started',
        );
      }

      final errorMessage = e.response?.statusCode == 401
          ? 'Unauthorized: Please log in again'
          : e.response?.statusCode == 403
          ? 'Forbidden: You do not have access to KYC status'
          : e.response?.data['message'] ??
                e.response?.data['error'] ??
                'Failed to fetch KYC status. Please try again.';

      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Submit KYC verification (initiate)
  Future<Map<String, dynamic>> submitKycVerification(
    KycVerificationRequest request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.kycInitiate,
        data: request.toJson(),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ??
          e.response?.data['error'] ??
          'Failed to submit KYC. Please try again.';

      throw Exception(errorMessage);
    }
  }

  /// Verify KYC with OTP
  Future<Map<String, dynamic>> verifyKycOtp(
    KycOtpVerificationRequest request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.kycVerifyOtp,
        data: request.toJson(),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ??
          e.response?.data['error'] ??
          'Invalid OTP. Please try again.';

      throw Exception(errorMessage);
    }
  }

  /// Verify face
  Future<Map<String, dynamic>> verifyFace(
    FaceVerificationRequest request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.kycFace,
        data: request.toJson(),
      );

      return response.data;
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ??
          e.response?.data['error'] ??
          'Face verification failed. Please try again.';

      throw Exception(errorMessage);
    }
  }
}

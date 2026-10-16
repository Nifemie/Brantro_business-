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
      
      // Handle list response (e.g. array of KYC verification records)
      if (payload is List) {
        if (payload.isEmpty) {
          return KycStatusResponse(
            status: 'NOT_STARTED',
            message: 'KYC verification not started',
          );
        }
        final lastItem = payload.last;
        if (lastItem is Map<String, dynamic>) {
          return KycStatusResponse.fromJson(lastItem);
        }
      }
      
      // Handle object response
      if (payload is Map<String, dynamic>) {
        return KycStatusResponse.fromJson(payload);
      }
      
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
  Future<KycInitiateResponse> submitKycVerification(
    KycVerificationRequest request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.kycInitiate,
        data: request.toJson(),
      );

      if (response.data != null) {
        return KycInitiateResponse.fromJson(response.data);
      }

      throw Exception('Empty response received from KYC initiation');
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

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data;
      }
      return {'success': true, 'data': data};
    } on DioException catch (e) {
      print('[KycRepository] verifyFace ERROR: status=${e.response?.statusCode}, body=${e.response?.data}');
      final errorMessage = e.response?.data is Map
          ? (e.response?.data['message'] ?? e.response?.data['error'] ?? 'Face verification failed.')
          : (e.response?.data?.toString() ?? 'Face verification failed. Please try again.');

      throw Exception(errorMessage);
    }
  }
}

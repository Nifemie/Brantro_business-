import 'dart:developer';

import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/signup_request.dart';
import 'models/signup_response.dart';
import 'models/validate_account_request.dart';
import 'models/verify_otp_request.dart';
import 'models/login_request.dart';
import 'models/login_response.dart';
import 'models/forgot_password_request.dart';
import 'models/forgot_password_response.dart';
import 'models/reset_password_request.dart';
import 'models/reset_password_response.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository(this.apiClient);

  /// Register a new user (generic for all roles)
  Future<SignUpResponse> signupUser(SignUpRequest request) async {
    try {
      print('========================================');
      print('[AuthRepository] Signup attempt for role: ${request.role}');
      print('[AuthRepository] Payload: ${request.toJson()}');
      final response = await apiClient.post(
        ApiEndpoints.signup,
        data: request.toJson(),
      );
      print('[AuthRepository] Signup response status: ${response.statusCode}');
      print('[AuthRepository] Signup response data: ${response.data}');
      print('========================================');

      final signupResponse = SignUpResponse.fromJson(response.data);
      return signupResponse;
    } on DioException catch (e) {
      print('========================================');
      print('[AuthRepository] Signup DioException status: ${e.response?.statusCode}');
      print('[AuthRepository] Signup DioException data: ${e.response?.data}');
      print('[AuthRepository] Signup DioException message: ${e.message}');
      print('========================================');
      throw Exception(
        _extractDioErrorMessage(e, 'Signup failed. Please try again.'),
      );
    } catch (e) {
      print('[AuthRepository] Signup unexpected error: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  String _extractDioErrorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data is Map) {
      final msg = data['message'] ?? data['error'];
      if (msg is List) {
        return msg.join(', ');
      } else if (msg != null && msg.toString().trim().isNotEmpty) {
        return msg.toString().trim();
      }
    } else if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }
    return fallback;
  }

  /// Validate account by sending OTP to user's email/phone
  Future<SignUpResponse> validateAccount(ValidateAccountRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.validateAccount,
        data: request.toJson(),
      );

      final validateResponse = SignUpResponse.fromJson(response.data);
      return validateResponse;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Account validation failed. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Verify user account with OTP
  Future<SignUpResponse> verifyAccount(VerifyOtpRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.verifyAccount,
        data: request.toJson(),
      );

      // The response structure matches SignUpResponse (User object in data)
      final verifyResponse = SignUpResponse.fromJson(response.data);
      return verifyResponse;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Verification failed. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Login user
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      print('========================================');
      print('[AuthRepository] Login attempt with username: ${request.username}');
      print('[AuthRepository] Posting to ${ApiEndpoints.login}...');
      
      final response = await apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      print('[AuthRepository] Login response status: ${response.statusCode}');
      print('[AuthRepository] Login response data: ${response.data}');

      final loginResponse = LoginResponse.fromJson(response.data);
      
      print('[AuthRepository] Parsed login response - Success: ${loginResponse.success}');
      print('[AuthRepository] User role: ${loginResponse.user?.role}');
      print('[AuthRepository] User ID: ${loginResponse.user?.id}');
      print('[AuthRepository] Access token present: ${loginResponse.accessToken != null}');
      print('========================================');
      
      return loginResponse;
    } on DioException catch (e) {
      print('========================================');
      print('[AuthRepository] DioException occurred');
      print('[AuthRepository] Status code: ${e.response?.statusCode}');
      print('[AuthRepository] Response data: ${e.response?.data}');
      print('[AuthRepository] Error message: ${e.message}');
      print('========================================');
      
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Login failed. Please check your credentials.',
      );
    } catch (e) {
      print('========================================');
      print('[AuthRepository] Unexpected error: $e');
      print('========================================');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Forgot password - Send OTP to user's email
  Future<ForgotPasswordResponse> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    log('[AuthRepository] forgotPassword called with: ${request.toJson()}');
    try {
      log('[AuthRepository] Posting to ${ApiEndpoints.forgotPassword}...');
      final response = await apiClient.post(
        ApiEndpoints.forgotPassword,
        data: request.toJson(),
      );
      log('[AuthRepository] API response received: ${response.statusCode}');

      final forgotPasswordResponse = ForgotPasswordResponse.fromJson(
        response.data,
      );
      return forgotPasswordResponse;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Failed to process forgot password request. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  /// Reset password with new password
  Future<ResetPasswordResponse> resetPassword(
    ResetPasswordRequest request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.resetPassword,
        data: request.toJson(),
      );

      final resetPasswordResponse = ResetPasswordResponse.fromJson(
        response.data,
      );
      return resetPasswordResponse;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Failed to reset password. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // TODO: Add logout, etc.
}

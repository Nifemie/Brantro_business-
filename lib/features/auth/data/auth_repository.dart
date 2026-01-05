import 'dart:developer';

import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/endpoints.dart';
import 'models/signup_request.dart';
import 'models/signup_response.dart';
import 'models/validate_account_request.dart';
import 'models/verify_otp_request.dart';
import 'models/user_model.dart';
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
      final response = await apiClient.post(
        ApiEndpoints.signup,
        data: request.toJson(),
      );

      final signupResponse = SignUpResponse.fromJson(response.data);
      return signupResponse;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Signup failed. Please try again.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
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
      final response = await apiClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);
      return loginResponse;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Login failed. Please check your credentials.',
      );
    } catch (e) {
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

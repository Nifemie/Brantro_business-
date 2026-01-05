import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/auth_repository.dart';
import '../data/models/signup_request.dart';
import '../data/models/validate_account_request.dart';
import '../data/models/verify_otp_request.dart';
import '../data/models/user_model.dart';
import '../data/models/login_request.dart';
import '../data/models/forgot_password_request.dart';
import '../data/models/reset_password_request.dart';

// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.read(apiClientProvider)),
);

// StateNotifier for Auth
class AuthNotifier extends StateNotifier<DataState<UserModel>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(DataState.initial());

  /// Register a new user (generic)
  Future<void> signupUser(SignUpRequest request) async {
    // Set loading state
    // Set loading state
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      // Call repository to make API request
      final response = await _repository.signupUser(request);

      // Update state with success
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.user != null ? [response.user!] : [],
        singleData: response.user,
        message: response.message,
      );

      log('[AuthNotifier] User signup successful: ${response.message}');
    } catch (e, stack) {
      // Update state with error
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );

      log('[AuthNotifier] User signup error: $e\n$stack');
    }
  }

  /// Request OTP for account validation
  Future<void> validateEmail(ValidateAccountRequest request) async {
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.validateAccount(request);

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.user != null ? [response.user!] : [],
        singleData: response.user,
        message: response.message,
      );

      log('[AuthNotifier] Email validation successful: ${response.message}');
    } catch (e, stack) {
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
      log('[AuthNotifier] Email validation error: $e\n$stack');
    }
  }

  /// Verify user account with OTP
  Future<void> verifyAccount(VerifyOtpRequest request) async {
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.verifyAccount(request);

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.user != null ? [response.user!] : [],
        singleData: response.user,
        message: response.message,
      );

      log(
        '[AuthNotifier] Account verification successful: ${response.message}',
      );
    } catch (e, stack) {
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
      log('[AuthNotifier] Account verification error: $e\n$stack');
    }
  }

  Future<void> login(LoginRequest request) async {
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.login(request);

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.user != null ? [response.user!] : [],
        singleData: response.user,
        message: response.message,
      );

      log('[AuthNotifier] Login successful: ${response.message}');
    } catch (e, stack) {
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
      log('[AuthNotifier] Login error: $e\n$stack');
    }
  }

  /// Clear any error messages
  void clearMessage() {
    state = state.copyWith(message: null);
  }

  /// Forgot password - Trigger OTP send
  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    log(
      '[AuthNotifier] forgotPassword called with identity: ${request.identity}',
    );
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      log('[AuthNotifier] Calling repository.forgotPassword...');
      final response = await _repository.forgotPassword(request);
      log('[AuthNotifier] Repository returned: ${response.toJson()}');

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: response.payload,
      );

      log('[AuthNotifier] Forgot password successful: ${response.message}');
    } catch (e, stack) {
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
      log('[AuthNotifier] Forgot password error: $e\n$stack');
    }
  }

  /// Reset password with new password
  Future<void> resetPassword(ResetPasswordRequest request) async {
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.resetPassword(request);

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        message: response.message,
      );

      log('[AuthNotifier] Password reset successful: ${response.message}');
    } catch (e, stack) {
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
      log('[AuthNotifier] Password reset error: $e\n$stack');
    }
  }

  /// Reset state to initial
  void reset() {
    state = DataState.initial();
  }
}

// Provider for AuthNotifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, DataState<UserModel>>(
      (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
    );

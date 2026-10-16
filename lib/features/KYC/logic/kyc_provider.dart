import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/kyc_models.dart';
import '../data/kyc_repository.dart';
import '../../../core/constants/kyc_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/service/session_service.dart';

// Provider for KycRepository
final kycRepositoryProvider = Provider<KycRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return KycRepository(apiClient);
});

/// KYC State
class KycState {
  final KycVerificationRequest? draftRequest;
  final KycStatusResponse? statusResponse;
  final bool isLoading;
  final String? error;
  final KycVerificationStatus verificationStatus;

  const KycState({
    this.draftRequest,
    this.statusResponse,
    this.isLoading = false,
    this.error,
    this.verificationStatus = KycVerificationStatus.notStarted,
  });

  const KycState.initial()
    : draftRequest = null,
      statusResponse = null,
      isLoading = false,
      error = null,
      verificationStatus = KycVerificationStatus.notStarted;

  KycState copyWith({
    KycVerificationRequest? draftRequest,
    KycStatusResponse? statusResponse,
    bool? isLoading,
    String? error,
    KycVerificationStatus? verificationStatus,
  }) {
    return KycState(
      draftRequest: draftRequest ?? this.draftRequest,
      statusResponse: statusResponse ?? this.statusResponse,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }
}

/// KYC Notifier
class KycNotifier extends StateNotifier<KycState> {
  final KycRepository _repository;

  KycNotifier(this._repository) : super(const KycState.initial());

  /// Fetch KYC status from API
  Future<void> fetchKycStatus() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getKycStatus();
      final status = _mapStringToStatus(response.status);

      state = state.copyWith(
        isLoading: false,
        statusResponse: response,
        verificationStatus: status,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        verificationStatus: KycVerificationStatus.notStarted,
      );
    }
  }

  /// Get KYC status string (for use in gates)
  Future<String> getKycStatusString() async {
    try {
      final response = await _repository.getKycStatus();
      return response.status?.toUpperCase() ?? 'NOT_STARTED';
    } catch (e) {
      return 'NOT_STARTED';
    }
  }

  /// Update draft request
  void updateDraftRequest(KycVerificationRequest request) {
    state = state.copyWith(draftRequest: request);
  }

  /// Clear draft
  void clearDraft() {
    state = state.copyWith(draftRequest: null);
  }

  /// Initiate KYC verification
  Future<KycInitiateResponse?> initiateKyc(KycVerificationRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.submitKycVerification(request);

      final statusEnum = _mapStringToStatus(response.status);
      state = state.copyWith(
        isLoading: false,
        verificationStatus: statusEnum != KycVerificationStatus.notStarted
            ? statusEnum
            : KycVerificationStatus.pending,
        statusResponse: KycStatusResponse(
          status: response.status,
          message: response.message ?? 'Verification in review',
          submittedAt: DateTime.now(),
          submittedData: request,
        ),
      );

      if (response.isVerified ||
          response.status == 'COMPLETED' ||
          response.status == 'APPROVED') {
        await _updateSessionVerified(true);
      }

      return response;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  /// Submit KYC verification (backward-compatibility alias)
  Future<bool> submitVerification(KycVerificationRequest request) async {
    final result = await initiateKyc(request);
    return result != null;
  }

  /// Verify face selfie with Base64 data
  Future<bool> verifyFace(String documentNumber, String imageBase64) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = FaceVerificationRequest(
        documentNumber: documentNumber,
        imageBase64: imageBase64,
      );

      final response = await _repository.verifyFace(request);
      final payload = response['payload'] ?? response['data'] ?? response;
      final status = (payload is Map ? payload['status'] : null)?.toString().toUpperCase();
      final isSuccess = response['success'] == true || status == 'COMPLETED' || status == 'APPROVED';

      await fetchKycStatus();
      if (isSuccess) {
        await _updateSessionVerified(true);
      }

      state = state.copyWith(isLoading: false);
      return isSuccess;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Verify KYC with OTP
  Future<bool> verifyOtp(String documentNumber, String otp) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = KycOtpVerificationRequest(
        documentNumber: documentNumber,
        otp: otp,
      );

      final response = await _repository.verifyKycOtp(request);
      final payload = response['payload'] ?? response['data'] ?? response;
      final status = (payload is Map ? payload['status'] : null)?.toString().toUpperCase();
      final isSuccess = response['success'] == true || status == 'COMPLETED' || status == 'APPROVED';

      // Fetch updated status
      await fetchKycStatus();
      if (isSuccess) {
        await _updateSessionVerified(true);
      }

      state = state.copyWith(isLoading: false);
      return isSuccess;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> _updateSessionVerified(bool isVerified) async {
    try {
      final user = await SessionService.getUser();
      if (user is Map<String, dynamic>) {
        final updated = Map<String, dynamic>.from(user);
        updated['isVerified'] = isVerified;
        updated['kycStatus'] = 'APPROVED';
        await SessionService.saveUser(updated);
      }
    } catch (_) {}
  }

  /// Update verification status (when received from backend)
  void updateVerificationStatus(KycVerificationStatus status) {
    state = state.copyWith(verificationStatus: status);
  }

  /// Map string status to enum
  KycVerificationStatus _mapStringToStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'COMPLETED':
      case 'APPROVED':
      case 'VERIFIED':
        return KycVerificationStatus.approved;
      case 'FACE_REQUIRED':
        return KycVerificationStatus.inReview;
      case 'PENDING':
      case 'IN_PROGRESS':
      case 'OTP_REQUIRED':
        return KycVerificationStatus.pending;
      case 'IN_REVIEW':
        return KycVerificationStatus.inReview;
      case 'REJECTED':
      case 'FAILED':
        return KycVerificationStatus.rejected;
      default:
        return KycVerificationStatus.notStarted;
    }
  }
}

/// KYC Provider
final kycProvider = StateNotifierProvider<KycNotifier, KycState>((ref) {
  final repository = ref.watch(kycRepositoryProvider);
  return KycNotifier(repository);
});

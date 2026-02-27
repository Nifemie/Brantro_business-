import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/kyc_models.dart';
import '../data/kyc_repository.dart';
import '../../../core/constants/kyc_constants.dart';
import '../../../core/network/api_client.dart';

// Providers
final apiClientProvider = Provider((ref) => ApiClient());

final kycRepositoryProvider = Provider((ref) {
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

  /// Submit KYC verification
  Future<bool> submitVerification(KycVerificationRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.submitKycVerification(request);

      // Fetch updated status
      await fetchKycStatus();

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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
      
      await _repository.verifyKycOtp(request);

      // Fetch updated status
      await fetchKycStatus();

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Update verification status (when received from backend)
  void updateVerificationStatus(KycVerificationStatus status) {
    state = state.copyWith(verificationStatus: status);
  }

  /// Map string status to enum
  KycVerificationStatus _mapStringToStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'APPROVED':
        return KycVerificationStatus.approved;
      case 'PENDING':
        return KycVerificationStatus.pending;
      case 'IN_REVIEW':
        return KycVerificationStatus.inReview;
      case 'REJECTED':
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/vetting_service.dart';
import '../data/models/vetting_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/data/data_state.dart';

// API Client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Repository provider
final vettingRepositoryProvider = Provider<VettingRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VettingRepository(apiClient);
});

// Notifier
class VettingNotifier extends StateNotifier<DataState<VettingOptionModel>> {
  final VettingRepository _repository;

  VettingNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchVettingOptions({int page = 0, int size = 20}) async {
    // Show initial loading only if no data exists
    if (state.data == null || state.data!.isEmpty) {
      state = state.copyWith(isInitialLoading: true, message: null);
    } else {
      state = state.copyWith(isPaginating: true, message: null);
    }

    try {
      final vettingOptions = await _repository.fetchVettingOptions(
        page: page,
        size: size,
      );

      state = state.copyWith(
        data: vettingOptions,
        isPaginating: false,
        isInitialLoading: false,
        isDataAvailable: true,
        currentPage: page,
        message: vettingOptions.isEmpty ? 'No vetting options available' : null,
      );
    } catch (e) {
      state = state.copyWith(
        isPaginating: false,
        isInitialLoading: false,
        message: e.toString(),
        isDataAvailable: state.data != null && state.data!.isNotEmpty,
      );
    }
  }

  void clearError() {
    state = state.copyWith(message: null);
  }
}

// Provider
final vettingProvider = StateNotifierProvider<VettingNotifier, DataState<VettingOptionModel>>((ref) {
  final repository = ref.watch(vettingRepositoryProvider);
  return VettingNotifier(repository);
});

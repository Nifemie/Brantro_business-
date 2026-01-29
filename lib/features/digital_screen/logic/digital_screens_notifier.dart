import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/digital_screen_repository.dart';
import '../data/models/digital_screen_model.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final digitalScreenRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DigitalScreenRepository(apiClient);
});

class DigitalScreensNotifier extends StateNotifier<DataState<DigitalScreenModel>> {
  final DigitalScreenRepository _repository;

  DigitalScreensNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchDigitalScreens({int page = 0, int size = 15}) async {
    log('[DigitalScreensNotifier] Fetching digital screens with page=$page, size=$size');
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.getDigitalScreens(page: page, size: size);
      log(
        '[DigitalScreensNotifier] Successfully fetched ${response.payload.screens.length} digital screens',
      );

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.payload.screens,
        currentPage: int.tryParse(response.payload.currentPage) ?? 0,
        totalPages: response.payload.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[DigitalScreensNotifier] Error fetching digital screens: $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Clear any error messages
  void clearMessage() {
    state = state.copyWith(message: null);
  }

  /// Reset state to initial
  void reset() {
    state = DataState.initial();
  }
}

final digitalScreensProvider = StateNotifierProvider<DigitalScreensNotifier, DataState<DigitalScreenModel>>(
  (ref) {
    final repository = ref.watch(digitalScreenRepositoryProvider);
    return DigitalScreensNotifier(repository);
  },
);

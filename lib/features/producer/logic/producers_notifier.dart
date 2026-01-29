import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/producer_repository.dart';
import '../data/models/producer_model.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final producerRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProducerRepository(apiClient);
});

class ProducersNotifier extends StateNotifier<DataState<ProducerModel>> {
  final ProducerRepository _repository;

  ProducersNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchProducers({int page = 1, int limit = 10}) async {
    log('[ProducersNotifier] Fetching producers with page=$page, limit=$limit');
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.getProducers(page: page, limit: limit);
      log(
        '[ProducersNotifier] Successfully fetched ${response.payload.producers.length} producers',
      );

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.payload.producers,
        currentPage: response.payload.currentPage,
        totalPages: response.payload.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[ProducersNotifier] Error fetching producers: $e\n$stack');
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

final producersProvider = StateNotifierProvider<ProducersNotifier, DataState<ProducerModel>>(
  (ref) {
    final repository = ref.watch(producerRepositoryProvider);
    return ProducersNotifier(repository);
  },
);

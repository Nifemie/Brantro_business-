import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/producer_repository.dart';
import '../data/models/producer_model.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final producerRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ProducerRepository(apiClient);
});

class ProducersNotifier extends AsyncNotifier<DataState<ProducerModel>> {
  late final ProducerRepository _repository;

  @override
  Future<DataState<ProducerModel>> build() async {
    _repository = ref.read(producerRepositoryProvider);

    final response = await _repository.getProducers(page: 1, limit: 10);
    log(
      '[ProducersNotifier] Successfully fetched ${response.payload.producers.length} producers',
    );

    return DataState<ProducerModel>(
      data: response.payload.producers,
      isDataAvailable: response.payload.producers.isNotEmpty,
      currentPage: response.payload.currentPage,
      totalPages: response.payload.totalPages,
      message: response.payload.producers.isEmpty
          ? 'No producers available'
          : null,
    );
  }

  Future<void> fetchProducers({int page = 1, int limit = 10}) async {
    log('[ProducersNotifier] Fetching producers with page=$page, limit=$limit');
    state = const AsyncLoading();

    try {
      final response = await _repository.getProducers(page: page, limit: limit);
      log(
        '[ProducersNotifier] Successfully fetched ${response.payload.producers.length} producers',
      );

      state = AsyncData(
        DataState<ProducerModel>(
          data: response.payload.producers,
          isDataAvailable: response.payload.producers.isNotEmpty,
          currentPage: response.payload.currentPage,
          totalPages: response.payload.totalPages,
          message: null,
        ),
      );
    } catch (e, stackTrace) {
      log('[ProducersNotifier] Error fetching producers: $e\n$stackTrace');
      state = AsyncError(e, stackTrace);
    }
  }

  /// Clear any error messages
  void clearMessage() {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(message: null));
  }

  /// Reset state to initial
  void reset() {
    state = AsyncData(DataState.initial());
  }
}

final producersProvider =
    AsyncNotifierProvider<ProducersNotifier, DataState<ProducerModel>>(
      ProducersNotifier.new,
    );

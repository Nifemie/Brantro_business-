import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/producer_repository.dart';
import '../data/models/producer_model.dart';
import '../../../core/network/api_client.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final producerRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProducerRepository(apiClient);
});

class ProducersNotifier extends StateNotifier<ProducersState> {
  final ProducerRepository _repository;

  ProducersNotifier(this._repository) : super(const ProducersState.initial());

  Future<void> fetchProducers({int page = 1, int limit = 10}) async {
    log('[ProducersNotifier] Fetching producers with page=$page, limit=$limit');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getProducers(page: page, limit: limit);
      log(
        '[ProducersNotifier] Successfully fetched ${response.payload.producers.length} producers',
      );

      state = state.copyWith(
        isLoading: false,
        producers: response.payload.producers,
        currentPage: response.payload.currentPage,
        totalPages: response.payload.totalPages,
      );
    } catch (e) {
      log('[ProducersNotifier] Error fetching producers: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

class ProducersState {
  final bool isLoading;
  final List<ProducerModel> producers;
  final String? error;
  final int currentPage;
  final int totalPages;

  const ProducersState({
    required this.isLoading,
    required this.producers,
    this.error,
    required this.currentPage,
    required this.totalPages,
  });

  const ProducersState.initial()
    : isLoading = false,
      producers = const [],
      error = null,
      currentPage = 0,
      totalPages = 0;

  ProducersState copyWith({
    bool? isLoading,
    List<ProducerModel>? producers,
    String? error,
    int? currentPage,
    int? totalPages,
  }) {
    return ProducersState(
      isLoading: isLoading ?? this.isLoading,
      producers: producers ?? this.producers,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

final producersProvider = StateNotifierProvider<ProducersNotifier, ProducersState>((
  ref,
) {
  final repository = ref.watch(producerRepositoryProvider);
  return ProducersNotifier(repository);
});

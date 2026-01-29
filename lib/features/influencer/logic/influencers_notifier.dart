import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/influencer_repository.dart';
import '../data/models/influencer_model.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final influencerRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return InfluencerRepository(apiClient);
});

class InfluencersNotifier extends StateNotifier<DataState<InfluencerModel>> {
  final InfluencerRepository _repository;

  InfluencersNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchInfluencers({int page = 0, int limit = 10}) async {
    log(
      '[InfluencersNotifier] Fetching influencers with page=$page, limit=$limit',
    );
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.getInfluencers(
        page: page,
        limit: limit,
      );
      log(
        '[InfluencersNotifier] Successfully fetched ${response.influencers.length} influencers',
      );

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.influencers,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[InfluencersNotifier] Error fetching influencers: $e\n$stack');
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

final influencersProvider =
    StateNotifierProvider<InfluencersNotifier, DataState<InfluencerModel>>((ref) {
      final repository = ref.watch(influencerRepositoryProvider);
      return InfluencersNotifier(repository);
    });

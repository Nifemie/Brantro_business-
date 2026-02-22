import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/influencer_repository.dart';
import '../data/models/influencer_model.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final influencerRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return InfluencerRepository(apiClient);
});

class InfluencersNotifier extends AsyncNotifier<DataState<InfluencerModel>> {
  late final InfluencerRepository _repository;

  @override
  Future<DataState<InfluencerModel>> build() async {
    _repository = ref.read(influencerRepositoryProvider);

    final response = await _repository.getInfluencers(page: 0, limit: 10);
    log(
      '[InfluencersNotifier] Successfully fetched ${response.influencers.length} influencers',
    );

    return DataState<InfluencerModel>(
      data: response.influencers,
      isDataAvailable: response.influencers.isNotEmpty,
      currentPage: response.currentPage,
      totalPages: response.totalPages,
      message: response.influencers.isEmpty ? 'No influencers available' : null,
    );
  }

  Future<void> fetchInfluencers({int page = 0, int limit = 10}) async {
    log(
      '[InfluencersNotifier] Fetching influencers with page=$page, limit=$limit',
    );
    state = const AsyncLoading();

    try {
      final response = await _repository.getInfluencers(
        page: page,
        limit: limit,
      );
      log(
        '[InfluencersNotifier] Successfully fetched ${response.influencers.length} influencers',
      );

      state = AsyncData(
        DataState<InfluencerModel>(
          data: response.influencers,
          isDataAvailable: response.influencers.isNotEmpty,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          message: null,
        ),
      );
    } catch (e, stackTrace) {
      log('[InfluencersNotifier] Error fetching influencers: $e\n$stackTrace');
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

final influencersProvider =
    AsyncNotifierProvider<InfluencersNotifier, DataState<InfluencerModel>>(
      InfluencersNotifier.new,
    );

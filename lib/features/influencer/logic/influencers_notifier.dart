import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/influencer_repository.dart';
import '../data/models/influencer_model.dart';
import '../../../core/network/api_client.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final influencerRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return InfluencerRepository(apiClient);
});

class InfluencersNotifier extends StateNotifier<InfluencersState> {
  final InfluencerRepository _repository;

  InfluencersNotifier(this._repository)
    : super(const InfluencersState.initial());

  Future<void> fetchInfluencers({int page = 0, int limit = 10}) async {
    log(
      '[InfluencersNotifier] Fetching influencers with page=$page, limit=$limit',
    );
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getInfluencers(
        page: page,
        limit: limit,
      );
      log(
        '[InfluencersNotifier] Successfully fetched ${response.influencers.length} influencers',
      );

      state = state.copyWith(
        isLoading: false,
        influencers: response.influencers,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      );
    } catch (e) {
      log('[InfluencersNotifier] Error fetching influencers: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

class InfluencersState {
  final bool isLoading;
  final List<InfluencerModel> influencers;
  final String? error;
  final int currentPage;
  final int totalPages;

  const InfluencersState({
    required this.isLoading,
    required this.influencers,
    this.error,
    required this.currentPage,
    required this.totalPages,
  });

  const InfluencersState.initial()
    : isLoading = false,
      influencers = const [],
      error = null,
      currentPage = 0,
      totalPages = 0;

  InfluencersState copyWith({
    bool? isLoading,
    List<InfluencerModel>? influencers,
    String? error,
    int? currentPage,
    int? totalPages,
  }) {
    return InfluencersState(
      isLoading: isLoading ?? this.isLoading,
      influencers: influencers ?? this.influencers,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

final influencersProvider =
    StateNotifierProvider<InfluencersNotifier, InfluencersState>((ref) {
      final repository = ref.watch(influencerRepositoryProvider);
      return InfluencersNotifier(repository);
    });

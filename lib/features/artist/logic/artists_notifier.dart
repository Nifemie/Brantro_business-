import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/artist_repository.dart';
import '../data/models/artist_model.dart';
import '../../../core/network/api_client.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final artistRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ArtistRepository(apiClient);
});

class ArtistsNotifier extends StateNotifier<ArtistsState> {
  final ArtistRepository _repository;

  ArtistsNotifier(this._repository) : super(const ArtistsState.initial());

  Future<void> fetchArtists({int page = 1, int limit = 10}) async {
    log('[ArtistsNotifier] Fetching artists with page=$page, limit=$limit');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getArtists(page: page, limit: limit);
      log(
        '[ArtistsNotifier] Successfully fetched ${response.payload.artists.length} artists',
      );

      state = state.copyWith(
        isLoading: false,
        artists: response.payload.artists,
        currentPage: response.payload.currentPage,
        totalPages: response.payload.totalPages,
      );
    } catch (e) {
      log('[ArtistsNotifier] Error fetching artists: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

class ArtistsState {
  final bool isLoading;
  final List<ArtistModel> artists;
  final String? error;
  final int currentPage;
  final int totalPages;

  const ArtistsState({
    required this.isLoading,
    required this.artists,
    this.error,
    required this.currentPage,
    required this.totalPages,
  });

  const ArtistsState.initial()
    : isLoading = false,
      artists = const [],
      error = null,
      currentPage = 0,
      totalPages = 0;

  ArtistsState copyWith({
    bool? isLoading,
    List<ArtistModel>? artists,
    String? error,
    int? currentPage,
    int? totalPages,
  }) {
    return ArtistsState(
      isLoading: isLoading ?? this.isLoading,
      artists: artists ?? this.artists,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

final artistsProvider = StateNotifierProvider<ArtistsNotifier, ArtistsState>((
  ref,
) {
  final repository = ref.watch(artistRepositoryProvider);
  return ArtistsNotifier(repository);
});

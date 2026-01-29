import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/artist_repository.dart';
import '../data/models/artist_model.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final artistRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ArtistRepository(apiClient);
});

class ArtistsNotifier extends StateNotifier<DataState<ArtistModel>> {
  final ArtistRepository _repository;

  ArtistsNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchArtists({int page = 1, int limit = 10}) async {
    log('[ArtistsNotifier] Fetching artists with page=$page, limit=$limit');
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.getArtists(page: page, limit: limit);
      log(
        '[ArtistsNotifier] Successfully fetched ${response.payload.artists.length} artists',
      );

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.payload.artists,
        currentPage: response.payload.currentPage,
        totalPages: response.payload.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[ArtistsNotifier] Error fetching artists: $e\n$stack');
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

  /// Search users by query with optional role filter
  Future<void> searchUsers({
    required String query,
    int page = 0,
    String? role,
  }) async {
    log('[ArtistsNotifier] Searching users with query=$query, page=$page, role=$role');
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.searchUsers(
        query: query,
        page: page,
        role: role,
      );
      log(
        '[ArtistsNotifier] Successfully found ${response.payload.artists.length} users',
      );

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.payload.artists,
        currentPage: response.payload.currentPage,
        totalPages: response.payload.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[ArtistsNotifier] Error searching users: $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Reset state to initial
  void reset() {
    state = DataState.initial();
  }
}

final artistsProvider = StateNotifierProvider<ArtistsNotifier, DataState<ArtistModel>>(
  (ref) {
    final repository = ref.watch(artistRepositoryProvider);
    return ArtistsNotifier(repository);
  },
);

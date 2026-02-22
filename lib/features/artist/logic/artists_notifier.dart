import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/artist_repository.dart';
import '../data/models/artist_model.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final artistRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ArtistRepository(apiClient);
});

class ArtistsNotifier extends AsyncNotifier<DataState<ArtistModel>> {
  late final ArtistRepository _repository;

  @override
  Future<DataState<ArtistModel>> build() async {
    _repository = ref.read(artistRepositoryProvider);

    final response = await _repository.getArtists(page: 1, limit: 10);
    log(
      '[ArtistsNotifier] Successfully fetched ${response.payload.artists.length} artists',
    );

    return DataState<ArtistModel>(
      data: response.payload.artists,
      isDataAvailable: response.payload.artists.isNotEmpty,
      currentPage: response.payload.currentPage,
      totalPages: response.payload.totalPages,
      message: response.payload.artists.isEmpty ? 'No artists available' : null,
    );
  }

  Future<void> fetchArtists({int page = 1, int limit = 10}) async {
    log('[ArtistsNotifier] Fetching artists with page=$page, limit=$limit');
    state = const AsyncLoading();

    try {
      final response = await _repository.getArtists(page: page, limit: limit);
      log(
        '[ArtistsNotifier] Successfully fetched ${response.payload.artists.length} artists',
      );

      state = AsyncData(
        DataState<ArtistModel>(
          data: response.payload.artists,
          isDataAvailable: response.payload.artists.isNotEmpty,
          currentPage: response.payload.currentPage,
          totalPages: response.payload.totalPages,
          message: null,
        ),
      );
    } catch (e, stackTrace) {
      log('[ArtistsNotifier] Error fetching artists: $e\n$stackTrace');
      state = AsyncError(e, stackTrace);
    }
  }

  /// Clear any error messages
  void clearMessage() {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(message: null));
  }

  /// Search users by query with optional role filter
  Future<void> searchUsers({
    required String query,
    int page = 0,
    String? role,
  }) async {
    log(
      '[ArtistsNotifier] Searching users with query=$query, page=$page, role=$role',
    );
    state = const AsyncLoading();

    try {
      final response = await _repository.searchUsers(
        query: query,
        page: page,
        role: role,
      );
      log(
        '[ArtistsNotifier] Successfully found ${response.payload.artists.length} users',
      );

      state = AsyncData(
        DataState<ArtistModel>(
          data: response.payload.artists,
          isDataAvailable: response.payload.artists.isNotEmpty,
          currentPage: response.payload.currentPage,
          totalPages: response.payload.totalPages,
          message: null,
        ),
      );
    } catch (e, stackTrace) {
      log('[ArtistsNotifier] Error searching users: $e\n$stackTrace');
      state = AsyncError(e, stackTrace);
    }
  }

  /// Reset state to initial
  void reset() {
    state = AsyncData(DataState.initial());
  }
}

final artistsProvider =
    AsyncNotifierProvider<ArtistsNotifier, DataState<ArtistModel>>(
      ArtistsNotifier.new,
    );

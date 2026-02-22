import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/models/tv_station_model.dart';
import '../data/tv_station_repository.dart';

// API Client provider
final apiClientProvider = Provider((ref) => ApiClient());

// Repository provider
final tvStationRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return TvStationRepository(apiClient);
});

// Notifier class
class TvStationsNotifier extends AsyncNotifier<DataState<TvStationModel>> {
  late final TvStationRepository repository;

  @override
  Future<DataState<TvStationModel>> build() async {
    repository = ref.read(tvStationRepositoryProvider);

    final response = await repository.getTvStations(page: 0, limit: 10);
    log(
      '[TvStationsNotifier] Successfully fetched ${response.page.length} TV stations',
    );

    return DataState<TvStationModel>(
      data: response.page,
      isDataAvailable: response.page.isNotEmpty,
      currentPage: response.currentPage,
      totalPages: response.totalPages,
      message: response.page.isEmpty ? 'No TV stations available' : null,
    );
  }

  Future<void> fetchTvStations(int page, int limit) async {
    log(
      '[TvStationsNotifier] Fetching TV stations with page=$page, limit=$limit',
    );
    state = const AsyncLoading();

    try {
      final response = await repository.getTvStations(page: page, limit: limit);
      log(
        '[TvStationsNotifier] Successfully fetched ${response.page.length} TV stations',
      );

      state = AsyncData(
        DataState<TvStationModel>(
          data: response.page,
          isDataAvailable: response.page.isNotEmpty,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          message: null,
        ),
      );
    } catch (e, stackTrace) {
      log('[TvStationsNotifier] Error fetching TV stations: $e\n$stackTrace');
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

// Provider
final tvStationsProvider =
    AsyncNotifierProvider<TvStationsNotifier, DataState<TvStationModel>>(
      TvStationsNotifier.new,
    );

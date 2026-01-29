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
  final apiClient = ref.watch(apiClientProvider);
  return TvStationRepository(apiClient);
});

// Notifier class
class TvStationsNotifier extends StateNotifier<DataState<TvStationModel>> {
  final TvStationRepository repository;

  TvStationsNotifier(this.repository) : super(DataState.initial());

  Future<void> fetchTvStations(int page, int limit) async {
    log('[TvStationsNotifier] Fetching TV stations with page=$page, limit=$limit');
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await repository.getTvStations(page: page, limit: limit);
      log('[TvStationsNotifier] Successfully fetched ${response.page.length} TV stations');
      
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.page,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[TvStationsNotifier] Error fetching TV stations: $e\n$stack');
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

// Provider
final tvStationsProvider =
    StateNotifierProvider<TvStationsNotifier, DataState<TvStationModel>>((ref) {
      final repository = ref.watch(tvStationRepositoryProvider);
      return TvStationsNotifier(repository);
    });

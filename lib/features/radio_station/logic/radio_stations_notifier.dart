import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/models/radio_station_model.dart';
import '../data/radio_station_repository.dart';

// API Client provider
final apiClientProvider = Provider((ref) => ApiClient());

// Repository provider
final radioStationRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RadioStationRepository(apiClient);
});

// Notifier class
class RadioStationsNotifier extends StateNotifier<DataState<RadioStationModel>> {
  final RadioStationRepository repository;

  RadioStationsNotifier(this.repository) : super(DataState.initial());

  Future<void> fetchRadioStations(int page, int limit) async {
    log('[RadioStationsNotifier] Fetching radio stations with page=$page, limit=$limit');
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await repository.getRadioStations(
        page: page,
        limit: limit,
      );
      log('[RadioStationsNotifier] Successfully fetched ${response.page.length} radio stations');
      
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.page,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[RadioStationsNotifier] Error fetching radio stations: $e\n$stack');
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
final radioStationsProvider =
    StateNotifierProvider<RadioStationsNotifier, DataState<RadioStationModel>>((ref) {
      final repository = ref.watch(radioStationRepositoryProvider);
      return RadioStationsNotifier(repository);
    });

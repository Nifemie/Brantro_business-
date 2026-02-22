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
  final apiClient = ref.read(apiClientProvider);
  return RadioStationRepository(apiClient);
});

// Notifier class
class RadioStationsNotifier
    extends AsyncNotifier<DataState<RadioStationModel>> {
  late final RadioStationRepository repository;

  @override
  Future<DataState<RadioStationModel>> build() async {
    repository = ref.read(radioStationRepositoryProvider);

    final response = await repository.getRadioStations(page: 0, limit: 10);
    log(
      '[RadioStationsNotifier] Successfully fetched ${response.page.length} radio stations',
    );

    return DataState<RadioStationModel>(
      data: response.page,
      isDataAvailable: response.page.isNotEmpty,
      currentPage: response.currentPage,
      totalPages: response.totalPages,
      message: response.page.isEmpty ? 'No radio stations available' : null,
    );
  }

  Future<void> fetchRadioStations(int page, int limit) async {
    log(
      '[RadioStationsNotifier] Fetching radio stations with page=$page, limit=$limit',
    );
    state = const AsyncLoading();

    try {
      final response = await repository.getRadioStations(
        page: page,
        limit: limit,
      );
      log(
        '[RadioStationsNotifier] Successfully fetched ${response.page.length} radio stations',
      );

      state = AsyncData(
        DataState<RadioStationModel>(
          data: response.page,
          isDataAvailable: response.page.isNotEmpty,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          message: null,
        ),
      );
    } catch (e, stackTrace) {
      log(
        '[RadioStationsNotifier] Error fetching radio stations: $e\n$stackTrace',
      );
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
final radioStationsProvider =
    AsyncNotifierProvider<RadioStationsNotifier, DataState<RadioStationModel>>(
      RadioStationsNotifier.new,
    );

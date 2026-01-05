import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/models/radio_station_model.dart';
import '../data/radio_station_repository.dart';
import '../data/models/radio_station_response.dart';

// API Client provider
final apiClientProvider = Provider((ref) => ApiClient());

// Repository provider
final radioStationRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RadioStationRepository(apiClient);
});

// State class
class RadioStationsState {
  final bool isLoading;
  final List<RadioStationModel> radioStations;
  final String? error;
  final int currentPage;
  final int totalPages;

  RadioStationsState({
    required this.isLoading,
    required this.radioStations,
    this.error,
    required this.currentPage,
    required this.totalPages,
  });

  RadioStationsState copyWith({
    bool? isLoading,
    List<RadioStationModel>? radioStations,
    String? error,
    int? currentPage,
    int? totalPages,
  }) {
    return RadioStationsState(
      isLoading: isLoading ?? this.isLoading,
      radioStations: radioStations ?? this.radioStations,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

// Notifier class
class RadioStationsNotifier extends StateNotifier<RadioStationsState> {
  final RadioStationRepository repository;

  RadioStationsNotifier(this.repository)
    : super(
        RadioStationsState(
          isLoading: false,
          radioStations: [],
          currentPage: 0,
          totalPages: 0,
        ),
      );

  Future<void> fetchRadioStations(int page, int limit) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await repository.getRadioStations(
        page: page,
        limit: limit,
      );
      state = state.copyWith(
        isLoading: false,
        radioStations: response.page,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Provider
final radioStationsProvider =
    StateNotifierProvider<RadioStationsNotifier, RadioStationsState>((ref) {
      final repository = ref.watch(radioStationRepositoryProvider);
      return RadioStationsNotifier(repository);
    });

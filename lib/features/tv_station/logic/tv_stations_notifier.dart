import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/models/tv_station_model.dart';
import '../data/tv_station_repository.dart';
import '../data/models/tv_station_response.dart';

// API Client provider
final apiClientProvider = Provider((ref) => ApiClient());

// Repository provider
final tvStationRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TvStationRepository(apiClient);
});

// State class
class TvStationsState {
  final bool isLoading;
  final List<TvStationModel> tvStations;
  final String? error;
  final int currentPage;
  final int totalPages;

  TvStationsState({
    required this.isLoading,
    required this.tvStations,
    this.error,
    required this.currentPage,
    required this.totalPages,
  });

  TvStationsState copyWith({
    bool? isLoading,
    List<TvStationModel>? tvStations,
    String? error,
    int? currentPage,
    int? totalPages,
  }) {
    return TvStationsState(
      isLoading: isLoading ?? this.isLoading,
      tvStations: tvStations ?? this.tvStations,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

// Notifier class
class TvStationsNotifier extends StateNotifier<TvStationsState> {
  final TvStationRepository repository;

  TvStationsNotifier(this.repository)
    : super(
        TvStationsState(
          isLoading: false,
          tvStations: [],
          currentPage: 0,
          totalPages: 0,
        ),
      );

  Future<void> fetchTvStations(int page, int limit) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await repository.getTvStations(page: page, limit: limit);
      state = state.copyWith(
        isLoading: false,
        tvStations: response.page,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Provider
final tvStationsProvider =
    StateNotifierProvider<TvStationsNotifier, TvStationsState>((ref) {
      final repository = ref.watch(tvStationRepositoryProvider);
      return TvStationsNotifier(repository);
    });

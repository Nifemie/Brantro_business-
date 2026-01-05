import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/models/media_house_model.dart';
import '../data/media_house_repository.dart';
import '../data/models/media_house_response.dart';

// API Client provider
final apiClientProvider = Provider((ref) => ApiClient());

// Repository provider
final mediaHouseRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MediaHouseRepository(apiClient);
});

// State class
class MediaHousesState {
  final bool isLoading;
  final List<MediaHouseModel> mediaHouses;
  final String? error;
  final int currentPage;
  final int totalPages;

  MediaHousesState({
    required this.isLoading,
    required this.mediaHouses,
    this.error,
    required this.currentPage,
    required this.totalPages,
  });

  MediaHousesState copyWith({
    bool? isLoading,
    List<MediaHouseModel>? mediaHouses,
    String? error,
    int? currentPage,
    int? totalPages,
  }) {
    return MediaHousesState(
      isLoading: isLoading ?? this.isLoading,
      mediaHouses: mediaHouses ?? this.mediaHouses,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

// Notifier class
class MediaHousesNotifier extends StateNotifier<MediaHousesState> {
  final MediaHouseRepository repository;

  MediaHousesNotifier(this.repository)
    : super(
        MediaHousesState(
          isLoading: false,
          mediaHouses: [],
          currentPage: 0,
          totalPages: 0,
        ),
      );

  Future<void> fetchMediaHouses(int page, int limit) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await repository.getMediaHouses(
        page: page,
        limit: limit,
      );
      state = state.copyWith(
        isLoading: false,
        mediaHouses: response.page,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Provider
final mediaHousesProvider =
    StateNotifierProvider<MediaHousesNotifier, MediaHousesState>((ref) {
      final repository = ref.watch(mediaHouseRepositoryProvider);
      return MediaHousesNotifier(repository);
    });

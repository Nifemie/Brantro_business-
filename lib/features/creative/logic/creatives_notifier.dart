import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro/core/network/api_client.dart';
import '../data/creative_repository.dart';
import '../data/models/creative_model.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final creativeRepositoryProvider = Provider<CreativeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CreativeRepository(apiClient);
});

class CreativesState {
  final bool isLoading;
  final List<CreativeModel> creatives;
  final String? error;
  final int currentPage;
  final int totalPages;

  CreativesState({
    this.isLoading = false,
    this.creatives = const [],
    this.error,
    this.currentPage = 0,
    this.totalPages = 0,
  });

  CreativesState copyWith({
    bool? isLoading,
    List<CreativeModel>? creatives,
    String? error,
    int? currentPage,
    int? totalPages,
  }) {
    return CreativesState(
      isLoading: isLoading ?? this.isLoading,
      creatives: creatives ?? this.creatives,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class CreativesNotifier extends StateNotifier<CreativesState> {
  final CreativeRepository _repository;

  CreativesNotifier(this._repository) : super(CreativesState());

  Future<void> fetchCreatives({int page = 0, int limit = 10}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getCreatives(page: page, limit: limit);
      state = state.copyWith(
        isLoading: false,
        creatives: response.creatives,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final creativesProvider =
    StateNotifierProvider<CreativesNotifier, CreativesState>((ref) {
      final repository = ref.watch(creativeRepositoryProvider);
      return CreativesNotifier(repository);
    });

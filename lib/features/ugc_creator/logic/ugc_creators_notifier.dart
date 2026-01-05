import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro/core/network/api_client.dart';
import '../data/ugc_creator_repository.dart';
import '../data/models/ugc_creator_model.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final ugcCreatorRepositoryProvider = Provider<UgcCreatorRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UgcCreatorRepository(apiClient);
});

class UgcCreatorsState {
  final bool isLoading;
  final List<UgcCreatorModel> ugcCreators;
  final String? error;
  final int currentPage;
  final int totalPages;

  UgcCreatorsState({
    this.isLoading = false,
    this.ugcCreators = const [],
    this.error,
    this.currentPage = 0,
    this.totalPages = 0,
  });

  UgcCreatorsState copyWith({
    bool? isLoading,
    List<UgcCreatorModel>? ugcCreators,
    String? error,
    int? currentPage,
    int? totalPages,
  }) {
    return UgcCreatorsState(
      isLoading: isLoading ?? this.isLoading,
      ugcCreators: ugcCreators ?? this.ugcCreators,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class UgcCreatorsNotifier extends StateNotifier<UgcCreatorsState> {
  final UgcCreatorRepository _repository;

  UgcCreatorsNotifier(this._repository) : super(UgcCreatorsState());

  Future<void> fetchUgcCreators({int page = 0, int limit = 10}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _repository.getUgcCreators(
        page: page,
        limit: limit,
      );
      state = state.copyWith(
        isLoading: false,
        ugcCreators: response.ugcCreators,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final ugcCreatorsProvider =
    StateNotifierProvider<UgcCreatorsNotifier, UgcCreatorsState>((ref) {
      final repository = ref.watch(ugcCreatorRepositoryProvider);
      return UgcCreatorsNotifier(repository);
    });

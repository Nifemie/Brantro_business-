import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro/core/data/data_state.dart';
import 'package:brantro/core/network/api_client.dart';
import '../data/ugc_creator_repository.dart';
import '../data/models/ugc_creator_model.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final ugcCreatorRepositoryProvider = Provider<UgcCreatorRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UgcCreatorRepository(apiClient);
});

class UgcCreatorsNotifier extends StateNotifier<DataState<UgcCreatorModel>> {
  final UgcCreatorRepository _repository;

  UgcCreatorsNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchUgcCreators({int page = 0, int limit = 10}) async {
    log('[UgcCreatorsNotifier] Fetching UGC creators with page=$page, limit=$limit');
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.getUgcCreators(
        page: page,
        limit: limit,
      );
      log('[UgcCreatorsNotifier] Successfully fetched ${response.ugcCreators.length} UGC creators');
      
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.ugcCreators,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[UgcCreatorsNotifier] Error fetching UGC creators: $e\n$stack');
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

final ugcCreatorsProvider =
    StateNotifierProvider<UgcCreatorsNotifier, DataState<UgcCreatorModel>>((ref) {
      final repository = ref.watch(ugcCreatorRepositoryProvider);
      return UgcCreatorsNotifier(repository);
    });

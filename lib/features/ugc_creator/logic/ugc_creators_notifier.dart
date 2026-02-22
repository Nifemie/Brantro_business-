import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro/core/data/data_state.dart';
import 'package:brantro/core/network/api_client.dart';
import '../data/ugc_creator_repository.dart';
import '../data/models/ugc_creator_model.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final ugcCreatorRepositoryProvider = Provider<UgcCreatorRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return UgcCreatorRepository(apiClient);
});

class UgcCreatorsNotifier extends AsyncNotifier<DataState<UgcCreatorModel>> {
  late final UgcCreatorRepository _repository;

  @override
  Future<DataState<UgcCreatorModel>> build() async {
    _repository = ref.read(ugcCreatorRepositoryProvider);

    final response = await _repository.getUgcCreators(page: 0, limit: 10);
    log(
      '[UgcCreatorsNotifier] Successfully fetched ${response.ugcCreators.length} UGC creators',
    );

    return DataState<UgcCreatorModel>(
      data: response.ugcCreators,
      isDataAvailable: response.ugcCreators.isNotEmpty,
      currentPage: response.currentPage,
      totalPages: response.totalPages,
      message: response.ugcCreators.isEmpty
          ? 'No UGC creators available'
          : null,
    );
  }

  Future<void> fetchUgcCreators({int page = 0, int limit = 10}) async {
    log(
      '[UgcCreatorsNotifier] Fetching UGC creators with page=$page, limit=$limit',
    );
    state = const AsyncLoading();

    try {
      final response = await _repository.getUgcCreators(
        page: page,
        limit: limit,
      );
      log(
        '[UgcCreatorsNotifier] Successfully fetched ${response.ugcCreators.length} UGC creators',
      );

      state = AsyncData(
        DataState<UgcCreatorModel>(
          data: response.ugcCreators,
          isDataAvailable: response.ugcCreators.isNotEmpty,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          message: null,
        ),
      );
    } catch (e, stackTrace) {
      log('[UgcCreatorsNotifier] Error fetching UGC creators: $e\n$stackTrace');
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

final ugcCreatorsProvider =
    AsyncNotifierProvider<UgcCreatorsNotifier, DataState<UgcCreatorModel>>(
      UgcCreatorsNotifier.new,
    );

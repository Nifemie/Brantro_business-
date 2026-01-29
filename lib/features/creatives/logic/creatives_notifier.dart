import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/creative_repository.dart';
import '../data/models/creative_model.dart';

final creativeRepositoryProvider = Provider((ref) {
  final apiClient = ApiClient();
  return CreativeRepository(apiClient);
});

class CreativesNotifier extends StateNotifier<DataState<CreativeModel>> {
  final CreativeRepository _repository;

  CreativesNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchCreatives({int page = 0, int size = 10}) async {
    log('[CreativesNotifier] Fetching creatives with page=$page, size=$size');
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.getCreatives(page: page, size: size);
      log('[CreativesNotifier] Successfully fetched ${response.payload.creatives.length} creatives');

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.payload.creatives,
        currentPage: response.payload.currentPage,
        totalPages: response.payload.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[CreativesNotifier] Error fetching creatives: $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void clearMessage() {
    state = state.copyWith(message: null);
  }

  void reset() {
    state = DataState.initial();
  }
}

final creativesProvider = StateNotifierProvider<CreativesNotifier, DataState<CreativeModel>>(
  (ref) {
    final repository = ref.watch(creativeRepositoryProvider);
    return CreativesNotifier(repository);
  },
);

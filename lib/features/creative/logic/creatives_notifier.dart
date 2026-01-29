import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro/core/data/data_state.dart';
import 'package:brantro/core/network/api_client.dart';
import '../data/creative_repository.dart';
import '../data/models/creative_model.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final creativeRepositoryProvider = Provider<CreativeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CreativeRepository(apiClient);
});

class CreativesNotifier extends StateNotifier<DataState<CreativeModel>> {
  final CreativeRepository _repository;

  CreativesNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchCreatives({int page = 0, int limit = 10}) async {
    log('[CreativesNotifier] Fetching creatives with page=$page, limit=$limit');
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.getCreatives(page: page, limit: limit);
      log('[CreativesNotifier] Successfully fetched ${response.creatives.length} creatives');
      
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.creatives,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
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

  /// Clear any error messages
  void clearMessage() {
    state = state.copyWith(message: null);
  }

  /// Reset state to initial
  void reset() {
    state = DataState.initial();
  }
}

final creativesProvider =
    StateNotifierProvider<CreativesNotifier, DataState<CreativeModel>>((ref) {
      final repository = ref.watch(creativeRepositoryProvider);
      return CreativesNotifier(repository);
    });

import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro/core/data/data_state.dart';
import 'package:brantro/core/network/api_client.dart';
import '../data/creative_repository.dart';
import '../data/models/creative_model.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final creativeRepositoryProvider = Provider<CreativeRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return CreativeRepository(apiClient);
});

class CreativesNotifier extends AsyncNotifier<DataState<CreativeModel>> {
  late final CreativeRepository _repository;

  @override
  Future<DataState<CreativeModel>> build() async {
    _repository = ref.read(creativeRepositoryProvider);

    final response = await _repository.getCreatives(page: 0, limit: 10);
    log(
      '[CreativesNotifier] Successfully fetched ${response.creatives.length} creatives',
    );

    return DataState<CreativeModel>(
      data: response.creatives,
      isDataAvailable: response.creatives.isNotEmpty,
      currentPage: response.currentPage,
      totalPages: response.totalPages,
      message: response.creatives.isEmpty ? 'No creatives available' : null,
    );
  }

  Future<void> fetchCreatives({int page = 0, int limit = 10}) async {
    log('[CreativesNotifier] Fetching creatives with page=$page, limit=$limit');
    state = const AsyncLoading();

    try {
      final response = await _repository.getCreatives(page: page, limit: limit);
      log(
        '[CreativesNotifier] Successfully fetched ${response.creatives.length} creatives',
      );

      state = AsyncData(
        DataState<CreativeModel>(
          data: response.creatives,
          isDataAvailable: response.creatives.isNotEmpty,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
          message: null,
        ),
      );
    } catch (e, stackTrace) {
      log('[CreativesNotifier] Error fetching creatives: $e\n$stackTrace');
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

final creativesProvider =
    AsyncNotifierProvider<CreativesNotifier, DataState<CreativeModel>>(
      CreativesNotifier.new,
    );

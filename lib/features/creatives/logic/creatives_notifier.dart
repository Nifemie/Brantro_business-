import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
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

    final response = await _repository.getCreatives(page: 0, size: 10);
    log(
      '[CreativesNotifier] Successfully fetched ${response.payload.creatives.length} creatives',
    );

    return DataState<CreativeModel>(
      data: response.payload.creatives,
      isDataAvailable: response.payload.creatives.isNotEmpty,
      currentPage: response.payload.currentPage,
      totalPages: response.payload.totalPages,
      message: response.payload.creatives.isEmpty
          ? 'No creatives available'
          : null,
    );
  }

  Future<void> fetchCreatives({int page = 0, int size = 10}) async {
    log('[CreativesNotifier] Fetching creatives with page=$page, size=$size');
    state = const AsyncLoading();

    try {
      final response = await _repository.getCreatives(page: page, size: size);
      log(
        '[CreativesNotifier] Successfully fetched ${response.payload.creatives.length} creatives',
      );

      state = AsyncData(
        DataState<CreativeModel>(
          data: response.payload.creatives,
          isDataAvailable: response.payload.creatives.isNotEmpty,
          currentPage: response.payload.currentPage,
          totalPages: response.payload.totalPages,
          message: null,
        ),
      );
    } catch (e, stackTrace) {
      log('[CreativesNotifier] Error fetching creatives: $e\n$stackTrace');
      state = AsyncError(e, stackTrace);
    }
  }

  void clearMessage() {
    final current = state.asData?.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(message: null));
  }

  void reset() {
    state = AsyncData(DataState.initial());
  }
}

final creativesProvider =
    AsyncNotifierProvider<CreativesNotifier, DataState<CreativeModel>>(
      CreativesNotifier.new,
    );

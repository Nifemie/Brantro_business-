import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/digital_screen_repository.dart';
import '../data/models/digital_screen_model.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final digitalScreenRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return DigitalScreenRepository(apiClient);
});

class DigitalScreensNotifier
    extends AsyncNotifier<DataState<DigitalScreenModel>> {
  late final DigitalScreenRepository _repository;

  @override
  Future<DataState<DigitalScreenModel>> build() async {
    _repository = ref.read(digitalScreenRepositoryProvider);

    final response = await _repository.getDigitalScreens(page: 0, size: 15);
    log(
      '[DigitalScreensNotifier] Successfully fetched ${response.payload.screens.length} digital screens',
    );

    return DataState<DigitalScreenModel>(
      data: response.payload.screens,
      isDataAvailable: response.payload.screens.isNotEmpty,
      currentPage: int.tryParse(response.payload.currentPage) ?? 0,
      totalPages: response.payload.totalPages,
      message: response.payload.screens.isEmpty
          ? 'No digital screens available'
          : null,
    );
  }

  Future<void> fetchDigitalScreens({int page = 0, int size = 15}) async {
    log(
      '[DigitalScreensNotifier] Fetching digital screens with page=$page, size=$size',
    );
    state = const AsyncLoading();

    try {
      final response = await _repository.getDigitalScreens(
        page: page,
        size: size,
      );
      log(
        '[DigitalScreensNotifier] Successfully fetched ${response.payload.screens.length} digital screens',
      );

      state = AsyncData(
        DataState<DigitalScreenModel>(
          data: response.payload.screens,
          isDataAvailable: response.payload.screens.isNotEmpty,
          currentPage: int.tryParse(response.payload.currentPage) ?? 0,
          totalPages: response.payload.totalPages,
          message: null,
        ),
      );
    } catch (e, stackTrace) {
      log(
        '[DigitalScreensNotifier] Error fetching digital screens: $e\n$stackTrace',
      );
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

final digitalScreensProvider =
    AsyncNotifierProvider<
      DigitalScreensNotifier,
      DataState<DigitalScreenModel>
    >(DigitalScreensNotifier.new);

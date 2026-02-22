import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/billboard_repository.dart';
import '../data/models/billboard_model.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final billboardRepositoryProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return BillboardRepository(apiClient);
});

class BillboardsNotifier extends AsyncNotifier<DataState<BillboardModel>> {
  late final BillboardRepository _repository;

  @override
  Future<DataState<BillboardModel>> build() async {
    _repository = ref.read(billboardRepositoryProvider);

    final response = await _repository.getBillboards(page: 0, size: 15);
    log(
      '[BillboardsNotifier] Successfully fetched ${response.payload.billboards.length} billboards',
    );

    return DataState<BillboardModel>(
      data: response.payload.billboards,
      isDataAvailable: response.payload.billboards.isNotEmpty,
      currentPage: int.tryParse(response.payload.currentPage) ?? 0,
      totalPages: response.payload.totalPages,
      message: response.payload.billboards.isEmpty
          ? 'No billboards available'
          : null,
    );
  }

  Future<void> fetchBillboards({int page = 0, int size = 15}) async {
    log('[BillboardsNotifier] Fetching billboards with page=$page, size=$size');
    state = const AsyncLoading();

    try {
      final response = await _repository.getBillboards(page: page, size: size);
      log(
        '[BillboardsNotifier] Successfully fetched ${response.payload.billboards.length} billboards',
      );

      state = AsyncData(
        DataState<BillboardModel>(
          data: response.payload.billboards,
          isDataAvailable: response.payload.billboards.isNotEmpty,
          currentPage: int.tryParse(response.payload.currentPage) ?? 0,
          totalPages: response.payload.totalPages,
          message: null,
        ),
      );
    } catch (e, stackTrace) {
      log('[BillboardsNotifier] Error fetching billboards: $e\n$stackTrace');
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

final billboardsProvider =
    AsyncNotifierProvider<BillboardsNotifier, DataState<BillboardModel>>(
      BillboardsNotifier.new,
    );

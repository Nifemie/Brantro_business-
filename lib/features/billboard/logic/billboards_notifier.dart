import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../../../core/network/api_client.dart';
import '../data/billboard_repository.dart';
import '../data/models/billboard_model.dart';

final apiClientProvider = Provider((ref) => ApiClient());

final billboardRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BillboardRepository(apiClient);
});

class BillboardsNotifier extends StateNotifier<DataState<BillboardModel>> {
  final BillboardRepository _repository;

  BillboardsNotifier(this._repository) : super(DataState.initial());

  Future<void> fetchBillboards({int page = 0, int size = 15}) async {
    log('[BillboardsNotifier] Fetching billboards with page=$page, size=$size');
    
    state = state.copyWith(
      isInitialLoading: true,
      message: null,
      isDataAvailable: false,
    );

    try {
      final response = await _repository.getBillboards(page: page, size: size);
      log(
        '[BillboardsNotifier] Successfully fetched ${response.payload.billboards.length} billboards',
      );

      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: true,
        data: response.payload.billboards,
        currentPage: int.tryParse(response.payload.currentPage) ?? 0,
        totalPages: response.payload.totalPages,
        message: null,
      );
    } catch (e, stack) {
      log('[BillboardsNotifier] Error fetching billboards: $e\n$stack');
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

final billboardsProvider = StateNotifierProvider<BillboardsNotifier, DataState<BillboardModel>>(
  (ref) {
    final repository = ref.watch(billboardRepositoryProvider);
    return BillboardsNotifier(repository);
  },
);

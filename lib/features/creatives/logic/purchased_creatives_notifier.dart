import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/models/purchased_creative_model.dart';
import '../data/purchased_creatives_repository.dart';

final purchasedCreativesRepositoryProvider = Provider<PurchasedCreativesRepository>((ref) {
  final apiClient = ApiClient();
  return PurchasedCreativesRepository(apiClient);
});

final purchasedCreativesProvider =
    StateNotifierProvider<PurchasedCreativesNotifier, AsyncValue<PurchasedCreativesPayload?>>((ref) {
  final repository = ref.watch(purchasedCreativesRepositoryProvider);
  return PurchasedCreativesNotifier(repository);
});

class PurchasedCreativesNotifier extends StateNotifier<AsyncValue<PurchasedCreativesPayload?>> {
  final PurchasedCreativesRepository _repository;
  int _currentPage = 0;
  bool _hasMore = true;

  PurchasedCreativesNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchPurchasedCreatives();
  }

  Future<void> fetchPurchasedCreatives({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      state = const AsyncValue.loading();
    }

    if (!_hasMore && !refresh) return;

    try {
      final response = await _repository.fetchPurchasedCreatives(
        page: _currentPage,
        size: 10,
      );

      if (response.success && response.payload != null) {
        final payload = response.payload!;
        
        if (refresh || _currentPage == 0) {
          state = AsyncValue.data(payload);
        } else {
          // Append to existing data
          state.whenData((currentData) {
            if (currentData != null) {
              final updatedOrders = [...currentData.page, ...payload.page];
              state = AsyncValue.data(
                PurchasedCreativesPayload(
                  page: updatedOrders,
                  size: payload.size,
                  currentPage: payload.currentPage,
                  totalPages: payload.totalPages,
                ),
              );
            } else {
              state = AsyncValue.data(payload);
            }
          });
        }

        _hasMore = payload.currentPage < payload.totalPages - 1;
        _currentPage++;
      } else {
        state = AsyncValue.error('Failed to load creatives', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> loadMore() async {
    if (_hasMore && !state.isLoading) {
      await fetchPurchasedCreatives();
    }
  }

  Future<void> refresh() async {
    await fetchPurchasedCreatives(refresh: true);
  }
}

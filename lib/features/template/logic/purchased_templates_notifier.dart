import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/models/purchased_template_model.dart';
import '../data/repositories/purchased_templates_repository.dart';

final purchasedTemplatesRepositoryProvider = Provider<PurchasedTemplatesRepository>((ref) {
  final apiClient = ApiClient();
  return PurchasedTemplatesRepository(apiClient);
});

final purchasedTemplatesProvider =
    StateNotifierProvider<PurchasedTemplatesNotifier, AsyncValue<PurchasedTemplatesPayload?>>((ref) {
  final repository = ref.watch(purchasedTemplatesRepositoryProvider);
  return PurchasedTemplatesNotifier(repository);
});

class PurchasedTemplatesNotifier extends StateNotifier<AsyncValue<PurchasedTemplatesPayload?>> {
  final PurchasedTemplatesRepository _repository;
  int _currentPage = 0;
  bool _hasMore = true;

  PurchasedTemplatesNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchPurchasedTemplates();
  }

  Future<void> fetchPurchasedTemplates({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      state = const AsyncValue.loading();
    }

    if (!_hasMore && !refresh) return;

    try {
      final response = await _repository.fetchPurchasedTemplates(
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
                PurchasedTemplatesPayload(
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
        state = AsyncValue.error('Failed to load templates', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> loadMore() async {
    if (_hasMore && !state.isLoading) {
      await fetchPurchasedTemplates();
    }
  }

  Future<void> refresh() async {
    await fetchPurchasedTemplates(refresh: true);
  }
}

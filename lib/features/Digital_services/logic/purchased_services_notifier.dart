import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/models/purchased_service_model.dart';
import '../data/repositories/purchased_services_repository.dart';

final purchasedServicesRepositoryProvider = Provider<PurchasedServicesRepository>((ref) {
  final apiClient = ApiClient();
  return PurchasedServicesRepository(apiClient);
});

final purchasedServicesProvider =
    StateNotifierProvider<PurchasedServicesNotifier, AsyncValue<PurchasedServicesPayload?>>((ref) {
  final repository = ref.watch(purchasedServicesRepositoryProvider);
  return PurchasedServicesNotifier(repository);
});

class PurchasedServicesNotifier extends StateNotifier<AsyncValue<PurchasedServicesPayload?>> {
  final PurchasedServicesRepository _repository;
  int _currentPage = 0;
  bool _hasMore = true;

  PurchasedServicesNotifier(this._repository) : super(const AsyncValue.loading()) {
    fetchPurchasedServices();
  }

  Future<void> fetchPurchasedServices({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      state = const AsyncValue.loading();
    }

    if (!_hasMore && !refresh) return;

    try {
      final response = await _repository.fetchPurchasedServices(
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
                PurchasedServicesPayload(
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
        state = AsyncValue.error('Failed to load services', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> loadMore() async {
    if (_hasMore && !state.isLoading) {
      await fetchPurchasedServices();
    }
  }

  Future<void> refresh() async {
    await fetchPurchasedServices(refresh: true);
  }

  Future<bool> updateServiceRequirements({
    required int itemId,
    required String description,
    List<String>? links,
    List<Map<String, dynamic>>? files,
  }) async {
    try {
      await _repository.updateServiceRequirements(
        itemId: itemId,
        description: description,
        links: links,
        files: files,
      );
      
      // Refresh the list after successful update
      await refresh();
      return true;
    } catch (e, stackTrace) {
      return false;
    }
  }

  Future<bool> cancelServiceOrder({
    required int itemId,
  }) async {
    try {
      await _repository.cancelServiceOrder(itemId: itemId);
      
      // Refresh the list after successful cancellation
      await refresh();
      return true;
    } catch (e, stackTrace) {
      return false;
    }
  }
}

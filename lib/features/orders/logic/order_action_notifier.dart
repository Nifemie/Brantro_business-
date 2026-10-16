import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/orders_repository.dart';

final orderActionNotifierProvider = StateNotifierProvider<OrderActionNotifier, AsyncValue<void>>((ref) {
  return OrderActionNotifier(ref.read(ordersRepositoryProvider));
});

class OrderActionNotifier extends StateNotifier<AsyncValue<void>> {
  final OrdersRepository _repository;

  OrderActionNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> makeDecision({
    required dynamic itemId,
    required String decision,
    String? startDate,
    String? endDate,
    String? remark,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.makeItemDecision(
        itemId: itemId,
        decision: decision,
        startDate: startDate,
        endDate: endDate,
        remark: remark,
      );
      state = const AsyncValue.data(null);
      onSuccess();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      onError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> updateProgress({
    required dynamic itemId,
    required String remark,
    required int percent,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateItemProgress(
        itemId: itemId,
        remark: remark,
        percent: percent,
      );
      state = const AsyncValue.data(null);
      onSuccess();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      onError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> deliverWork({
    required dynamic itemId,
    required String feedback,
    String? attachmentUrl,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deliverItemWork(
        itemId: itemId,
        feedback: feedback,
        attachmentUrl: attachmentUrl,
      );
      state = const AsyncValue.data(null);
      onSuccess();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      onError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> requestRevision({
    required dynamic itemId,
    required String reason,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.requestItemRevision(
        itemId: itemId,
        reason: reason,
      );
      state = const AsyncValue.data(null);
      onSuccess();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      onError(e.toString().replaceAll('Exception: ', ''));
    }
  }
}

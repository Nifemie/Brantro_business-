import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../data/models/order_model.dart';
import '../data/repositories/orders_repository.dart';
import 'orders_notifier.dart';

export 'orders_notifier.dart';

final ordersProvider = StateNotifierProvider.autoDispose.family<OrdersNotifier, DataState<OrderModel>, Map<String, String>?>((ref, filters) {
  final repository = ref.read(ordersRepositoryProvider);
  return OrdersNotifier(repository, filters: filters);
});

final orderDetailProvider = FutureProvider.autoDispose.family<OrderModel, ({String id, String type})>((ref, args) async {
  final repository = ref.read(ordersRepositoryProvider);
  return await repository.fetchOrderDetails(args.id, args.type);
});

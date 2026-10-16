import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../data/models/order_model.dart';
import '../data/repositories/orders_repository.dart';

class OrdersNotifier extends StateNotifier<DataState<OrderModel>> {
  final OrdersRepository _repository;
  final Map<String, String>? filters;

  OrdersNotifier(this._repository, {this.filters}) : super(DataState.initial()) {
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final List<OrderModel> allOrders = [];

      final creativeId = filters?['creativeId'];
      final templateId = filters?['templateId'];
      final serviceId = filters?['serviceId'];

      if (templateId == null && serviceId == null) {
        // Fetch creative orders if we are not specifically filtering only by template/service
        final creativeOrders = await _repository.fetchCreativeOrders(creativeId: creativeId);
        allOrders.addAll(creativeOrders);
      }

      if (creativeId == null && serviceId == null) {
        // Fetch template orders if we are not specifically filtering only by creative/service
        final templateOrders = await _repository.fetchTemplateOrders(templateId: templateId);
        allOrders.addAll(templateOrders);
      }

      if (creativeId == null && templateId == null) {
        // Fetch service orders if we are not specifically filtering only by creative/template
        final serviceOrders = await _repository.fetchServiceOrders(serviceId: serviceId);
        allOrders.addAll(serviceOrders);
      }

      // Sort all orders by createdAt descending
      allOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      state = state.copyWith(data: allOrders, isInitialLoading: false);
    } catch (e) {
      state = state.copyWith(isInitialLoading: false, message: e.toString());
    }
  }

  Future<void> refreshOrders() async {
    await _fetchOrders();
  }

  Future<void> updateOrderStatus(String orderId, String newStatus, {String? itemStatus}) async {
    final currentOrders = state.data ?? [];
    final updatedOrders = currentOrders.map((order) {
      if (order.id == orderId) {
        final updatedMetadata = Map<String, dynamic>.from(order.metadata ?? {});
        if (updatedMetadata.containsKey('items')) {
          final itemsList = List<dynamic>.from(updatedMetadata['items'] as List? ?? []);
          if (itemsList.isNotEmpty) {
            final firstItem = Map<String, dynamic>.from(itemsList[0] as Map? ?? {});
            firstItem['status'] = itemStatus ?? (newStatus == 'in_progress' ? 'ACCEPTED' : newStatus);
            itemsList[0] = firstItem;
            updatedMetadata['items'] = itemsList;
          }
        }
        return order.copyWith(
          status: newStatus,
          itemStatus: itemStatus ?? (newStatus == 'in_progress' ? 'ACCEPTED' : (newStatus == 'failed' || newStatus == 'rejected' ? 'REJECTED' : null)),
          metadata: updatedMetadata,
          updatedAt: DateTime.now(),
        );
      }
      return order;
    }).toList();

    state = state.copyWith(data: updatedOrders);
  }

  Future<void> deleteOrder(String orderId) async {
    final currentOrders = state.data ?? [];
    final updatedOrders = currentOrders.where((order) => order.id != orderId).toList();
    state = state.copyWith(data: updatedOrders);
  }
}

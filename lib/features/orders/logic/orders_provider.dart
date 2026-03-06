import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/order_model.dart';

class OrdersState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? error;
  final String selectedFilter;

  OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
    this.selectedFilter = 'all',
  });

  OrdersState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    String? error,
    String? selectedFilter,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  List<OrderModel> get filteredOrders {
    if (selectedFilter == 'all') {
      return orders;
    }
    return orders.where((order) => order.serviceType == selectedFilter).toList();
  }
}

class OrdersNotifier extends StateNotifier<OrdersState> {
  OrdersNotifier() : super(OrdersState()) {
    _loadMockOrders();
  }

  void _loadMockOrders() {
    // Mock data for demonstration
    final mockOrders = [
      OrderModel(
        id: 'ORD-001',
        serviceType: 'billboard',
        serviceName: 'Airport Road Billboard',
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        customerPhone: '08012345678',
        amount: 150000,
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        description: 'Premium billboard placement for Q1 campaign',
      ),
      OrderModel(
        id: 'ORD-002',
        serviceType: 'template',
        serviceName: 'Social Media Template Pack',
        customerName: 'Jane Smith',
        customerEmail: 'jane@example.com',
        customerPhone: '08087654321',
        amount: 25000,
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        description: 'Instagram and Facebook template bundle',
      ),
      OrderModel(
        id: 'ORD-003',
        serviceType: 'screen',
        serviceName: 'Mall Digital Screen',
        customerName: 'Mike Johnson',
        customerEmail: 'mike@example.com',
        customerPhone: '08098765432',
        amount: 200000,
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        description: 'Digital screen advertising in shopping mall',
      ),
      OrderModel(
        id: 'ORD-004',
        serviceType: 'creative',
        serviceName: 'Brand Video Production',
        customerName: 'Sarah Williams',
        customerEmail: 'sarah@example.com',
        customerPhone: '08011223344',
        amount: 500000,
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        description: '30-second brand promotional video',
      ),
      OrderModel(
        id: 'ORD-005',
        serviceType: 'wall',
        serviceName: 'City Center Wall Ad',
        customerName: 'David Brown',
        customerEmail: 'david@example.com',
        customerPhone: '08055667788',
        amount: 180000,
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        description: 'Large wall advertisement in city center',
      ),
    ];

    state = state.copyWith(orders: mockOrders);
  }

  void setFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  Future<void> refreshOrders() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    _loadMockOrders();
    state = state.copyWith(isLoading: false);
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId) {
        return order.copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        );
      }
      return order;
    }).toList();

    state = state.copyWith(orders: updatedOrders);
  }

  Future<void> deleteOrder(String orderId) async {
    final updatedOrders = state.orders.where((order) => order.id != orderId).toList();
    state = state.copyWith(orders: updatedOrders);
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier();
});

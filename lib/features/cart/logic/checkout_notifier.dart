import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/checkout_repository.dart';
import '../data/models/template_order_request.dart';
import '../data/models/template_order_response.dart';
import '../data/models/creative_order_request.dart';
import '../data/models/creative_order_response.dart';
import '../data/models/service_order_request.dart';
import '../data/models/service_order_response.dart';

final checkoutRepositoryProvider = Provider((ref) {
  final apiClient = ApiClient();
  return CheckoutRepository(apiClient);
});

class CheckoutState {
  final bool isLoading;
  final bool isSuccess;
  final String? message;
  final TemplateOrderData? orderData;

  CheckoutState({
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
    this.orderData,
  });

  CheckoutState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
    TemplateOrderData? orderData,
  }) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message,
      orderData: orderData ?? this.orderData,
    );
  }
}

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final CheckoutRepository _repository;

  CheckoutNotifier(this._repository) : super(CheckoutState());

  Future<void> submitTemplateOrder(TemplateOrderRequest request) async {
    log('[CheckoutNotifier] Submitting template order');
    
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      message: null,
    );

    try {
      final response = await _repository.submitTemplateOrder(request);
      log('[CheckoutNotifier] Order submitted successfully: ${response.message}');

      state = state.copyWith(
        isLoading: false,
        isSuccess: response.success,
        message: response.message,
        orderData: response.data,
      );
    } catch (e, stack) {
      log('[CheckoutNotifier] Error submitting order: $e\n$stack');
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> submitCreativeOrder(CreativeOrderRequest request) async {
    log('[CheckoutNotifier] Submitting creative order');
    
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      message: null,
    );

    try {
      final response = await _repository.submitCreativeOrder(request);
      log('[CheckoutNotifier] Creative order submitted successfully: ${response.message}');

      state = state.copyWith(
        isLoading: false,
        isSuccess: response.success,
        message: response.message,
        orderData: response.data != null 
            ? TemplateOrderData(
                orderId: response.data!.orderId,
                reference: response.data!.reference,
                status: response.data!.status,
                amount: response.data!.amount,
                currency: response.data!.currency,
                paymentMethod: response.data!.paymentMethod,
                createdAt: response.data!.createdAt,
              )
            : null,
      );
    } catch (e, stack) {
      log('[CheckoutNotifier] Error submitting creative order: $e\n$stack');
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> submitServiceOrder(ServiceOrderRequest request) async {
    log('[CheckoutNotifier] Submitting service order');
    
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      message: null,
    );

    try {
      final response = await _repository.submitServiceOrder(request);
      log('[CheckoutNotifier] Service order submitted successfully: ${response.message}');

      state = state.copyWith(
        isLoading: false,
        isSuccess: response.success,
        message: response.message,
        orderData: response.data != null 
            ? TemplateOrderData(
                orderId: response.data!.orderId,
                reference: response.data!.reference,
                status: response.data!.status,
                amount: response.data!.amount,
                currency: response.data!.currency,
                paymentMethod: response.data!.paymentMethod,
                createdAt: response.data!.createdAt,
              )
            : null,
      );
    } catch (e, stack) {
      log('[CheckoutNotifier] Error submitting service order: $e\n$stack');
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void clearMessage() {
    state = state.copyWith(message: null);
  }

  void reset() {
    state = CheckoutState();
  }
}

final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>(
  (ref) {
    final repository = ref.watch(checkoutRepositoryProvider);
    return CheckoutNotifier(repository);
  },
);

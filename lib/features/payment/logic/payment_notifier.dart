import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/data_state.dart';
import '../data/payment_repository.dart';
import '../data/models/payment_request.dart';
import '../data/models/payment_verification_response.dart';
import '../service/paystack_service.dart';
import '../../../core/network/api_client.dart';
import '../../auth/logic/auth_notifiers.dart'; // Import for apiClientProvider

final paymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, DataState<PaymentVerificationResponse>>(
  (ref) => PaymentNotifier(ref.read(apiClientProvider)),
);

class PaymentNotifier extends StateNotifier<DataState<PaymentVerificationResponse>> {
  final ApiClient _apiClient;
  late final PaystackService _paystackService;

  PaymentNotifier(this._apiClient) : super(DataState.initial()) {
    _paystackService = PaystackService(_apiClient);
  }

  /// Process complete payment flow (charge + poll for webhook completion)
  /// Webhook handles verification and processing automatically!
  Future<void> processPayment(BuildContext context, PaymentRequest request) async {
    state = state.copyWith(
      isInitialLoading: true,
      message: 'Processing payment...',
    );

    try {
      final orderStatus = await _paystackService.processPayment(
        context: context,
        request: request,
        onError: (error) {
          state = state.copyWith(
            isInitialLoading: false,
            message: error,
          );
        },
      );

      if (orderStatus != null) {
        state = state.copyWith(
          isInitialLoading: false,
          isDataAvailable: true,
          singleData: PaymentVerificationResponse(
            reference: orderStatus['reference'] ?? request.reference,
            status: orderStatus['status'] ?? 'success',
            amount: orderStatus['amount'] ?? request.amount,
            currency: orderStatus['currency'] ?? 'NGN',
            paidAt: orderStatus['paidAt'] ?? DateTime.now().toIso8601String(),
            channel: orderStatus['channel'] ?? 'card',
          ),
          message: 'Payment successful',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: 'Payment failed: ${e.toString()}',
      );
    }
  }

  /// Check order status (if you already have a reference)
  Future<void> checkOrderStatus(String reference) async {
    state = state.copyWith(
      isInitialLoading: true,
      message: 'Checking order status...',
    );

    try {
      final orderStatus = await _paystackService.checkOrderStatus(reference);
      if (orderStatus != null && orderStatus['processed'] == true) {
        state = state.copyWith(
          isInitialLoading: false,
          isDataAvailable: true,
          singleData: PaymentVerificationResponse(
            reference: orderStatus['reference'] ?? reference,
            status: orderStatus['status'] ?? 'success',
            amount: orderStatus['amount'] ?? 0.0,
            currency: orderStatus['currency'] ?? 'NGN',
            paidAt: orderStatus['paidAt'] ?? DateTime.now().toIso8601String(),
            channel: orderStatus['channel'] ?? 'card',
          ),
          message: 'Order processed successfully',
        );
      } else {
        state = state.copyWith(
          isInitialLoading: false,
          message: 'Order not processed yet',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isInitialLoading: false,
        message: 'Failed to check order status: ${e.toString()}',
      );
    }
  }

  /// Reset payment state
  void reset() {
    state = DataState.initial();
  }
}

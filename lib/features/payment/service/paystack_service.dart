import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import '../../../core/network/api_client.dart';
import '../data/models/payment_request.dart';
import '../../../core/constants/paystack_config.dart';

class PaystackService {
  final ApiClient _apiClient;

  PaystackService(this._apiClient);

  /// Initialize transaction on backend to get access code
  /// This is required for the webhook-only flow
  Future<String?> initializeTransaction(PaymentRequest request) async {
    try {
      final response = await _apiClient.post(
        '/api/v1/payment/initialize',
        data: {
          'email': request.email,
          'amount': (request.amount * 100).toInt(), // Convert to kobo
          'reference': request.reference,
          'currency': request.currency,
          'metadata': request.metadata,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        final accessCode = response.data['data']['access_code'];
        log('Access code obtained: $accessCode');
        return accessCode;
      }
      
      log('Failed to get access code: ${response.data}');
      return null;
    } catch (e) {
      log('Initialize transaction error: $e');
      return null;
    }
  }

  /// Charge card using Paystack popup
  Future<bool> chargeWithPaystack(
    BuildContext context,
    PaymentRequest request,
  ) async {
    try {
      bool paymentSuccessful = false;
      
      await FlutterPaystackPlus.openPaystackPopup(
        publicKey: PaystackConfig.publicKey,
        customerEmail: request.email,
        context: context,
        secretKey: PaystackConfig.secretKey,
        currency: 'NGN', // Required parameter
        amount: (request.amount * 100).toString(), // Convert to kobo
        reference: request.reference,
        callBackUrl: 'https://api.syroltech.com/brantro/webhook/paystack',
        onClosed: () {
          log('Payment popup closed');
          paymentSuccessful = false;
        },
        onSuccess: () {
          log('Payment successful');
          paymentSuccessful = true;
        },
      );
      
      return paymentSuccessful;
    } catch (e) {
      log('Payment error: $e');
      return false;
    }
  }

  /// Poll for order status after payment
  /// Webhook processes payment in background, frontend polls to check completion
  Future<Map<String, dynamic>?> checkOrderStatus(String reference) async {
    try {
      final response = await _apiClient.get(
        '/api/v1/orders/status/$reference',
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        return response.data['data'];
      }
      return null;
    } catch (e) {
      log('Check order status error: $e');
      return null;
    }
  }

  /// Complete payment flow: charge -> poll for completion
  /// Webhook handles verification and processing automatically
  Future<Map<String, dynamic>?> processPayment({
    required BuildContext context,
    required PaymentRequest request,
    required Function(String) onError,
    int maxPollingAttempts = 10,
    Duration pollingInterval = const Duration(seconds: 2),
  }) async {
    // Step 1: Launch Paystack payment popup
    final paymentSuccessful = await chargeWithPaystack(context, request);
    
    if (!paymentSuccessful) {
      onError('Payment was not completed');
      return null;
    }

    // Step 2: Poll backend to check if webhook processed the order
    log('Payment successful, waiting for webhook to process...');
    
    for (int attempt = 0; attempt < maxPollingAttempts; attempt++) {
      await Future.delayed(pollingInterval);
      
      final orderStatus = await checkOrderStatus(request.reference);
      if (orderStatus != null && orderStatus['processed'] == true) {
        log('Order processed successfully');
        return orderStatus;
      }
      
      log('Polling attempt ${attempt + 1}/$maxPollingAttempts...');
    }
    
    // Timeout - order not processed yet
    onError('Payment successful but order processing is taking longer than expected. Please check your orders.');
    return null;
  }
}

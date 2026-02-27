import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controllers/re_useable/app_color.dart';
import '../../logic/payment_notifier.dart';
import '../../data/models/payment_request.dart';

/// Modern payment button that uses Paystack SDK
/// 
/// Usage:
/// ```dart
/// PaymentButton(
///   paymentRequest: request,
///   onSuccess: () => print('Payment successful'),
///   onError: (error) => print('Payment failed: $error'),
/// )
/// ```
class PaymentButton extends ConsumerWidget {
  final PaymentRequest paymentRequest;
  final VoidCallback? onSuccess;
  final Function(String)? onError;
  final String? buttonText;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;

  const PaymentButton({
    required this.paymentRequest,
    this.onSuccess,
    this.onError,
    this.buttonText,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to payment state changes
    ref.listen(paymentNotifierProvider, (previous, next) {
      if (next.isDataAvailable) {
        // Payment successful
        onSuccess?.call();
      } else if (next.message != null && !next.isInitialLoading) {
        // Payment failed
        onError?.call(next.message!);
      }
    });

    final paymentState = ref.watch(paymentNotifierProvider);
    final isLoading = paymentState.isInitialLoading;

    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading
            ? () => _processPayment(ref)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  color: textColor ?? Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                buttonText ?? 'Pay ₦${paymentRequest.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _processPayment(WidgetRef ref) async {
    await ref.read(paymentNotifierProvider.notifier).processPayment(context, paymentRequest);
  }
}

/// Simple payment button with custom action
class SimplePaymentButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;

  const SimplePaymentButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

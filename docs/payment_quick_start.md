# Payment Quick Start Guide

## TL;DR - How to Accept Payment

```dart
// 1. Create payment request
final request = PaymentHelper.createCampaignPayment(
  email: userEmail,
  userId: userId,
  totalAmount: 50000.00,
  campaignId: 123,
);

// 2. Process payment (backend calls happen automatically)
await ref.read(paymentNotifierProvider.notifier).processPayment(request);

// 3. Listen for result
ref.listen(paymentNotifierProvider, (previous, next) {
  if (next.isDataAvailable) {
    print('Payment successful!');
  }
});
```

That's it! Backend calls happen automatically.

---

## Complete Example: Campaign Payment

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro/features/payment/utils/payment_helper.dart';
import 'package:brantro/features/payment/logic/payment_notifier.dart';
import 'package:brantro/features/payment/presentation/widgets/payment_button.dart';
import 'package:brantro/core/service/session_service.dart';

class CampaignCheckoutScreen extends ConsumerStatefulWidget {
  final int campaignId;
  final double totalAmount;
  
  const CampaignCheckoutScreen({
    required this.campaignId,
    required this.totalAmount,
    super.key,
  });

  @override
  ConsumerState<CampaignCheckoutScreen> createState() => _CampaignCheckoutScreenState();
}

class _CampaignCheckoutScreenState extends ConsumerState<CampaignCheckoutScreen> {
  
  Future<void> _handlePayment() async {
    // Get user details from session
    final userId = await SessionService.getUserId();
    final userEmail = await SessionService.getUserEmail();

    if (userId == null || userEmail == null) {
      _showError('Please login to continue');
      return;
    }

    // Create payment request with all required metadata
    final request = PaymentHelper.createCampaignPayment(
      email: userEmail,
      userId: userId,
      totalAmount: widget.totalAmount,
      campaignId: widget.campaignId,
      campaignName: 'Summer Campaign 2024', // Optional
    );

    // Process payment - this handles:
    // 1. Backend call to initialize
    // 2. SDK launches payment UI
    // 3. Backend call to verify
    await ref.read(paymentNotifierProvider.notifier).processPayment(request);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment successful!'), backgroundColor: Colors.green),
    );
    // Navigate to success screen or refresh data
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to payment state changes
    ref.listen(paymentNotifierProvider, (previous, next) {
      if (next.isDataAvailable) {
        // Payment successful
        _showSuccess();
      } else if (next.message != null && !next.isInitialLoading) {
        // Payment failed
        _showError(next.message!);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Campaign Payment', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Total Amount: ₦${widget.totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 32),
            
            // Option 1: Use PaymentButton widget (automatic)
            PaymentButton(
              paymentRequest: await _createPaymentRequest(),
              onSuccess: _showSuccess,
              onError: _showError,
            ),
            
            // OR Option 2: Use custom button
            ElevatedButton(
              onPressed: _handlePayment,
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<PaymentRequest> _createPaymentRequest() async {
    final userId = await SessionService.getUserId();
    final userEmail = await SessionService.getUserEmail();
    
    return PaymentHelper.createCampaignPayment(
      email: userEmail!,
      userId: userId!,
      totalAmount: widget.totalAmount,
      campaignId: widget.campaignId,
    );
  }
}
```

---

## All Payment Types

### 1. Campaign Payment
```dart
final request = PaymentHelper.createCampaignPayment(
  email: userEmail,
  userId: userId,
  totalAmount: 50000.00,
  campaignId: 123,
);
```

### 2. Creative Purchase
```dart
final request = PaymentHelper.createCreativePurchase(
  email: userEmail,
  userId: userId,
  totalAmount: 15000.00,
  creativeId: 456,
);
```

### 3. Service Order
```dart
final request = PaymentHelper.createServiceOrderPayment(
  email: userEmail,
  userId: userId,
  totalAmount: 75000.00,
  serviceId: 789,
  orderId: 1001,
);
```

### 4. Template Purchase
```dart
final request = PaymentHelper.createTemplatePurchase(
  email: userEmail,
  userId: userId,
  totalAmount: 5000.00,
  templateId: 321,
);
```

### 5. Wallet Top-up
```dart
final request = PaymentHelper.createWalletTopup(
  email: userEmail,
  userId: userId,
  amount: 20000.00,
);
```

---

## Backend Calls (Automatic)

When you call `processPayment()`, these happen automatically:

### Call 1: Initialize Payment
```
POST https://api.syroltech.com/brantro/api/v1/payment/initialize
```
**Sends:** Payment request with metadata  
**Receives:** access_code

### Call 2: Verify Payment
```
GET https://api.syroltech.com/brantro/api/v1/payment/verify/:reference
```
**Sends:** Payment reference  
**Receives:** Verification result

---

## Error Handling

```dart
ref.listen(paymentNotifierProvider, (previous, next) {
  if (next.isDataAvailable) {
    // ✅ Payment successful
    print('Payment verified: ${next.singleData?.reference}');
  } else if (next.message != null) {
    // ❌ Payment failed
    print('Error: ${next.message}');
  } else if (next.isInitialLoading) {
    // ⏳ Processing payment
    print('Processing...');
  }
});
```

---

## Testing

### Test Cards
- **Success:** 4084084084084081
- **Insufficient Funds:** 5060666666666666666

### Test Flow
1. Run app
2. Navigate to checkout
3. Click "Pay Now"
4. SDK opens payment UI
5. Enter test card
6. Payment completes
7. Backend verifies & credits wallet

---

## What You Need

### Frontend (Already Done ✅)
- Paystack SDK initialized
- Payment helpers created
- Backend calls configured

### Backend (Needs Implementation)
- POST `/api/v1/payment/initialize` - Initialize payment
- GET `/api/v1/payment/verify/:reference` - Verify & credit wallet

---

## Summary

**To accept payment:**
1. Create request with `PaymentHelper`
2. Call `processPayment(request)`
3. Listen for success/failure

**Backend calls happen automatically!**

No need to manually call ApiClient - it's all handled by PaystackService.

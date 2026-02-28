# Paystack Payment Usage Examples

## Setup Complete ✅

- Paystack SDK initialized in `app.dart`
- Test keys configured in `PaystackConfig`
- Payment helpers created for all payment types

---

## Payment Types & Metadata

### 1. Campaign Payment

```dart
import 'package:brantro/features/payment/utils/payment_helper.dart';
import 'package:brantro/features/payment/logic/payment_notifier.dart';

// In your campaign checkout screen
Future<void> _payCampaign() async {
  final request = PaymentHelper.createCampaignPayment(
    email: userEmail,
    userId: currentUserId,
    totalAmount: 50000.00, // ₦50,000
    campaignId: 123,
    campaignName: 'Summer Campaign 2024',
  );

  await ref.read(paymentNotifierProvider.notifier).processPayment(request);
}

// Metadata sent:
// {
//   "userId": 123,
//   "purpose": "campaign_payment",
//   "reference": "PAY-CAMPAIGN-1738012345678-A3F9",
//   "email": "user@example.com",
//   "amount": 50000.00,
//   "campaignId": 123,
//   "campaignName": "Summer Campaign 2024"
// }
```

### 2. Creative Purchase

```dart
Future<void> _purchaseCreative() async {
  final request = PaymentHelper.createCreativePurchase(
    email: userEmail,
    userId: currentUserId,
    totalAmount: 15000.00, // ₦15,000
    creativeId: 456,
    creativeName: 'Logo Design Package',
  );

  await ref.read(paymentNotifierProvider.notifier).processPayment(request);
}

// Metadata sent:
// {
//   "userId": 123,
//   "purpose": "creative_purchase",
//   "reference": "PAY-CREATIVE-1738012345678-B4G8",
//   "email": "user@example.com",
//   "amount": 15000.00,
//   "creativeId": 456,
//   "creativeName": "Logo Design Package"
// }
```

### 3. Service Order Payment

```dart
Future<void> _payForService() async {
  final request = PaymentHelper.createServiceOrderPayment(
    email: userEmail,
    userId: currentUserId,
    totalAmount: 75000.00, // ₦75,000
    serviceId: 789,
    serviceName: 'Video Production',
    orderId: 1001,
  );

  await ref.read(paymentNotifierProvider.notifier).processPayment(request);
}

// Metadata sent:
// {
//   "userId": 123,
//   "purpose": "service_order_payment",
//   "reference": "PAY-SERVICE-1738012345678-C5H9",
//   "email": "user@example.com",
//   "amount": 75000.00,
//   "serviceId": 789,
//   "serviceName": "Video Production",
//   "orderId": 1001
// }
```

### 4. Template Purchase

```dart
Future<void> _purchaseTemplate() async {
  final request = PaymentHelper.createTemplatePurchase(
    email: userEmail,
    userId: currentUserId,
    totalAmount: 5000.00, // ₦5,000
    templateId: 321,
    templateName: 'Social Media Template Pack',
  );

  await ref.read(paymentNotifierProvider.notifier).processPayment(request);
}

// Metadata sent:
// {
//   "userId": 123,
//   "purpose": "template_purchase",
//   "reference": "PAY-TEMPLATE-1738012345678-D6I0",
//   "email": "user@example.com",
//   "amount": 5000.00,
//   "templateId": 321,
//   "templateName": "Social Media Template Pack"
// }
```

### 5. Ad Slot Booking

```dart
Future<void> _bookAdSlot() async {
  final request = PaymentHelper.createAdSlotBooking(
    email: userEmail,
    userId: currentUserId,
    totalAmount: 100000.00, // ₦100,000
    adSlotId: 654,
    adSlotName: 'Billboard - Lekki Phase 1',
    startDate: DateTime(2024, 3, 1),
    endDate: DateTime(2024, 3, 31),
  );

  await ref.read(paymentNotifierProvider.notifier).processPayment(request);
}

// Metadata sent:
// {
//   "userId": 123,
//   "purpose": "ad_slot_booking",
//   "reference": "PAY-ADSLOT-1738012345678-E7J1",
//   "email": "user@example.com",
//   "amount": 100000.00,
//   "adSlotId": 654,
//   "adSlotName": "Billboard - Lekki Phase 1",
//   "startDate": "2024-03-01T00:00:00.000",
//   "endDate": "2024-03-31T00:00:00.000"
// }
```

### 6. Wallet Top-up

```dart
Future<void> _topupWallet() async {
  final request = PaymentHelper.createWalletTopup(
    email: userEmail,
    userId: currentUserId,
    amount: 20000.00, // ₦20,000
  );

  await ref.read(paymentNotifierProvider.notifier).processPayment(request);
}

// Metadata sent:
// {
//   "userId": 123,
//   "purpose": "wallet_topup",
//   "reference": "PAY-WALLET-1738012345678-F8K2",
//   "email": "user@example.com",
//   "amount": 20000.00
// }
```

---

## Complete Payment Flow Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro/features/payment/utils/payment_helper.dart';
import 'package:brantro/features/payment/logic/payment_notifier.dart';
import 'package:brantro/core/service/session_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final double totalAmount;
  final int campaignId;
  
  const CheckoutScreen({
    required this.totalAmount,
    required this.campaignId,
    super.key,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    try {
      // Get user details from session
      final userId = await SessionService.getUserId();
      final userEmail = await SessionService.getUserEmail();

      if (userId == null || userEmail == null) {
        _showError('Please login to continue');
        return;
      }

      // Create payment request
      final request = PaymentHelper.createCampaignPayment(
        email: userEmail,
        userId: userId,
        totalAmount: widget.totalAmount,
        campaignId: widget.campaignId,
      );

      // Process payment
      await ref.read(paymentNotifierProvider.notifier).processPayment(request);

    } catch (e) {
      _showError('Payment failed: ${e.toString()}');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to payment state
    ref.listen(paymentNotifierProvider, (previous, next) {
      if (next.isDataAvailable) {
        // Payment successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment successful!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to success screen or refresh data
        Navigator.pop(context, true);
      } else if (next.message != null && !next.isInitialLoading) {
        // Payment failed
        _showError(next.message!);
      }
    });

    final paymentState = ref.watch(paymentNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Total: ₦${widget.totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isProcessing || paymentState.isInitialLoading
                  ? null
                  : _processPayment,
              child: _isProcessing || paymentState.isInitialLoading
                  ? CircularProgressIndicator()
                  : Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Important Notes

### Metadata Structure (Required)
Every payment MUST include these fields in metadata:
```json
{
  "userId": 123,           // User ID from session
  "purpose": "...",        // Payment purpose
  "reference": "PAY-...",  // Payment reference
  "email": "user@...",     // User email
  "amount": 50000.00       // Amount in Naira
}
```

### Amount Conversion
- Frontend sends amount in **Naira** (e.g., 50000.00)
- PaymentRequest automatically converts to **kobo** (5000000)
- Backend receives amount in **kobo**

### Payment Purposes
Use constants from `PaymentPurpose` class:
- `PaymentPurpose.campaignPayment`
- `PaymentPurpose.creativePurchase`
- `PaymentPurpose.serviceOrderPayment`
- `PaymentPurpose.templatePurchase`
- `PaymentPurpose.adSlotBooking`
- `PaymentPurpose.walletTopup`

### Test Cards
- **Success:** 4084084084084081
- **Insufficient Funds:** 5060666666666666666

---

## Files Created/Updated

1. `lib/core/constants/paystack_config.dart` - API keys & purposes
2. `lib/features/payment/data/models/payment_request.dart` - Updated model
3. `lib/features/payment/utils/payment_helper.dart` - Helper methods
4. `lib/app.dart` - Paystack initialization

---

**Ready to use!** Just call the appropriate `PaymentHelper` method for your payment type.

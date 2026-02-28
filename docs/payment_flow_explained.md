# Payment Flow - How Backend is Called

## Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER CLICKS "PAY"                        │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ STEP 1: Initialize Payment (Backend Call #1)                    │
├─────────────────────────────────────────────────────────────────┤
│ Frontend: PaystackService.initializePayment(request)            │
│     ↓                                                            │
│ ApiClient.post('/api/v1/payment/initialize', data)              │
│     ↓                                                            │
│ YOUR BACKEND: Receives request with metadata                    │
│     {                                                            │
│       "email": "user@example.com",                              │
│       "amount": 5000000,  // kobo                               │
│       "reference": "PAY-CAMPAIGN-123-ABC",                      │
│       "metadata": {                                              │
│         "userId": 123,                                           │
│         "purpose": "campaign_payment",                           │
│         "amount": 50000.00                                       │
│       }                                                          │
│     }                                                            │
│     ↓                                                            │
│ YOUR BACKEND → Paystack API: Initialize transaction             │
│     ↓                                                            │
│ Paystack → YOUR BACKEND: Returns access_code                    │
│     ↓                                                            │
│ YOUR BACKEND → Frontend: Returns access_code                    │
│     {                                                            │
│       "status": true,                                            │
│       "data": {                                                  │
│         "access_code": "abc123xyz",                             │
│         "reference": "PAY-CAMPAIGN-123-ABC"                     │
│       }                                                          │
│     }                                                            │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ STEP 2: Launch Payment UI (SDK - No Backend)                    │
├─────────────────────────────────────────────────────────────────┤
│ Frontend: PaystackService.launchPayment(access_code)            │
│     ↓                                                            │
│ Paystack SDK: Opens native payment UI                           │
│     ↓                                                            │
│ User: Enters card details and completes payment                 │
│     ↓                                                            │
│ Paystack SDK → Frontend: Returns TransactionResponse            │
│     {                                                            │
│       "status": "success",                                       │
│       "reference": "PAY-CAMPAIGN-123-ABC",                      │
│       "message": "Approved"                                      │
│     }                                                            │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ STEP 3: Verify Payment (Backend Call #2)                        │
├─────────────────────────────────────────────────────────────────┤
│ Frontend: PaystackService.verifyPayment(reference)              │
│     ↓                                                            │
│ ApiClient.get('/api/v1/payment/verify/PAY-CAMPAIGN-123-ABC')    │
│     ↓                                                            │
│ YOUR BACKEND: Receives verification request                     │
│     ↓                                                            │
│ YOUR BACKEND → Paystack API: Verify transaction                 │
│     ↓                                                            │
│ Paystack → YOUR BACKEND: Confirms payment success               │
│     ↓                                                            │
│ YOUR BACKEND: Credits wallet / Completes order                  │
│     ↓                                                            │
│ YOUR BACKEND → Frontend: Returns verification result            │
│     {                                                            │
│       "status": true,                                            │
│       "data": {                                                  │
│         "reference": "PAY-CAMPAIGN-123-ABC",                    │
│         "status": "success",                                     │
│         "amount": 50000.00                                       │
│       }                                                          │
│     }                                                            │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    PAYMENT COMPLETE ✅                           │
└─────────────────────────────────────────────────────────────────┘
```

---

## Code Flow

### 1. User Initiates Payment

```dart
// In your checkout screen
final request = PaymentHelper.createCampaignPayment(
  email: userEmail,
  userId: userId,
  totalAmount: 50000.00,
  campaignId: 123,
);

// This calls the complete flow
await ref.read(paymentNotifierProvider.notifier).processPayment(request);
```

### 2. PaymentNotifier Calls PaystackService

```dart
// lib/features/payment/logic/payment_notifier.dart
Future<void> processPayment(PaymentRequest request) async {
  final verification = await _paystackService.processPayment(
    request: request,
    onError: (error) => state = DataState.error(error),
  );
}
```

### 3. PaystackService Orchestrates Everything

```dart
// lib/features/payment/service/paystack_service.dart
Future<PaymentVerificationResponse?> processPayment({
  required PaymentRequest request,
  required Function(String) onError,
}) async {
  // BACKEND CALL #1: Initialize
  final paymentResponse = await initializePayment(request);
  // ↑ This calls: ApiClient.post('/api/v1/payment/initialize')
  
  // SDK CALL: Launch UI
  final transactionResponse = await launchPayment(paymentResponse.accessCode);
  // ↑ This opens Paystack native UI
  
  // BACKEND CALL #2: Verify
  final verification = await verifyPayment(transactionResponse.reference);
  // ↑ This calls: ApiClient.get('/api/v1/payment/verify/:reference')
  
  return verification;
}
```

### 4. ApiClient Makes HTTP Requests

```dart
// lib/core/network/api_client.dart
// Already configured with base URL: https://api.syroltech.com/brantro

// Initialize payment
await _apiClient.post('/api/v1/payment/initialize', data: {...});

// Verify payment
await _apiClient.get('/api/v1/payment/verify/$reference');
```

---

## Backend Endpoints Called

### 1. Initialize Payment
```http
POST https://api.syroltech.com/brantro/api/v1/payment/initialize
Authorization: Bearer <user_token>
Content-Type: application/json

{
  "email": "user@example.com",
  "amount": 5000000,
  "reference": "PAY-CAMPAIGN-123-ABC",
  "currency": "NGN",
  "metadata": {
    "userId": 123,
    "purpose": "campaign_payment",
    "reference": "PAY-CAMPAIGN-123-ABC",
    "email": "user@example.com",
    "amount": 50000.00,
    "campaignId": 123
  },
  "channels": ["card", "bank", "ussd"]
}
```

**Backend Must Return:**
```json
{
  "status": true,
  "message": "Authorization URL created",
  "data": {
    "authorization_url": "https://checkout.paystack.com/abc123",
    "access_code": "abc123xyz",
    "reference": "PAY-CAMPAIGN-123-ABC"
  }
}
```

### 2. Verify Payment
```http
GET https://api.syroltech.com/brantro/api/v1/payment/verify/PAY-CAMPAIGN-123-ABC
Authorization: Bearer <user_token>
```

**Backend Must Return:**
```json
{
  "status": true,
  "message": "Verification successful",
  "data": {
    "id": 123456,
    "reference": "PAY-CAMPAIGN-123-ABC",
    "status": "success",
    "amount": 50000.00,
    "currency": "NGN",
    "paid_at": "2024-01-27T10:30:00Z"
  }
}
```

---

## How to Use (Simple Example)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro/features/payment/utils/payment_helper.dart';
import 'package:brantro/features/payment/logic/payment_notifier.dart';
import 'package:brantro/core/service/session_service.dart';

class PaymentExample extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // Get user info
        final userId = await SessionService.getUserId();
        final email = await SessionService.getUserEmail();

        // Create payment request
        final request = PaymentHelper.createCampaignPayment(
          email: email!,
          userId: userId!,
          totalAmount: 50000.00,
          campaignId: 123,
        );

        // Process payment (handles all backend calls automatically)
        await ref.read(paymentNotifierProvider.notifier).processPayment(request);
      },
      child: Text('Pay ₦50,000'),
    );
  }
}
```

---

## Summary

✅ **Backend calls are automatic** - handled by `PaystackService`  
✅ **Two backend endpoints called:**
   1. `/api/v1/payment/initialize` - Gets access code
   2. `/api/v1/payment/verify/:reference` - Verifies & credits wallet

✅ **You just call:** `processPayment(request)` - everything else is automatic!

---

## What Backend Team Needs to Implement

1. **POST /api/v1/payment/initialize**
   - Receive payment request with metadata
   - Call Paystack API to initialize
   - Return access_code

2. **GET /api/v1/payment/verify/:reference**
   - Verify payment with Paystack
   - Credit user wallet / complete order
   - Return verification result

That's it! The frontend is ready. Backend just needs these 2 endpoints.

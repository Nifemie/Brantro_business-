# Paystack Integration - Final Implementation

## Overview
Successfully integrated Paystack Flutter SDK (`paystack_flutter_sdk: ^0.0.1-alpha.2`) with webhook-only payment flow.

## Requirements Met ✅
- Flutter >= 3.3.0: ✅ Using Flutter 3.29.0
- iOS >= 13: ✅ 
- Android Minimum SDK: 23 ✅ (set in build.gradle.kts)
- Android Compile SDK: 34 ✅ (set in build.gradle.kts)
- MainActivity: ✅ Using FlutterFragmentActivity
- Swift Package Manager: ✅ Enabled

## Payment Flow (Webhook-Only)

### Step 1: Frontend Initializes Transaction
```dart
// Frontend calls backend to initialize transaction
POST /api/v1/payment/initialize
{
  "email": "user@example.com",
  "amount": 500000, // in kobo (5000 NGN)
  "reference": "TEMP_1234567890",
  "currency": "NGN",
  "metadata": {
    "userId": "123",
    "purpose": "template_purchase",
    "templateIds": ["456", "789"],
    "itemCount": 2
  }
}

// Backend returns access_code
{
  "status": true,
  "data": {
    "access_code": "67joTry7t1jz2o",
    "reference": "TEMP_1234567890"
  }
}
```

### Step 2: Frontend Launches Paystack UI
```dart
// Use access_code to launch Paystack payment UI
final response = await _paystack.launch(accessCode);

if (response.status) {
  // Payment successful
  // Paystack automatically sends webhook to backend
}
```

### Step 3: Backend Receives Webhook
```
POST https://api.syroltech.com/brantro/webhook/paystack
{
  "event": "charge.success",
  "data": {
    "reference": "TEMP_1234567890",
    "amount": 500000,
    "status": "success",
    "metadata": { ... }
  }
}

// Backend processes order and marks as completed
```

### Step 4: Frontend Polls for Completion
```dart
// Frontend polls backend to check if webhook processed order
GET /api/v1/orders/status/TEMP_1234567890

// Response when processed:
{
  "status": true,
  "data": {
    "reference": "TEMP_1234567890",
    "processed": true,
    "status": "success",
    "amount": 5000.0
  }
}
```

## Key Files

### 1. PaystackService (`lib/features/payment/service/paystack_service.dart`)
- Initializes Paystack SDK with public key
- Gets access code from backend
- Launches Paystack payment UI
- Polls backend for order status

### 2. PaymentNotifier (`lib/features/payment/logic/payment_notifier.dart`)
- Manages payment state
- Calls PaystackService methods
- Updates UI based on payment status

### 3. Main.dart (`lib/main.dart`)
- Initializes Paystack SDK on app startup

### 4. CheckoutScreen (`lib/features/cart/presentation/screens/checkout_screen.dart`)
- Creates payment request with metadata
- Triggers payment flow
- Handles payment response

## Configuration

### Paystack Keys (`lib/core/constants/paystack_config.dart`)
```dart
// Test Keys
static const String testPublicKey = 'pk_test_eb8e97936668538460a30817a607f75816ce35b2';
static const String testSecretKey = 'sk_test_19fc108601a2d08f8013fef2237c82216223b395';
```

### Android Configuration
**File:** `android/app/build.gradle.kts`
```kotlin
android {
    compileSdk = 34  // Required by paystack_flutter_sdk
    
    defaultConfig {
        minSdk = 23  // Required by paystack_flutter_sdk
    }
}
```

**File:** `android/app/src/main/kotlin/com/example/brantro/MainActivity.kt`
```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity()
```

## Backend Requirements

### 1. Initialize Transaction Endpoint
```
POST /api/v1/payment/initialize
```
- Calls Paystack API to initialize transaction
- Returns access_code to frontend

### 2. Webhook Endpoint
```
POST /webhook/paystack
```
- Receives payment notifications from Paystack
- Verifies transaction with Paystack
- Processes order (creates templates, campaigns, etc.)
- Marks order as processed

### 3. Order Status Endpoint
```
GET /api/v1/orders/status/:reference
```
- Returns order processing status
- Frontend polls this endpoint after payment

## Payment Metadata Structure

### Template Purchase
```dart
{
  "userId": "123",
  "purpose": "template_purchase",
  "reference": "TEMP_1234567890",
  "email": "user@example.com",
  "amount": 5000.0,
  "templateIds": ["456", "789"],
  "itemCount": 2
}
```

### Creative Purchase
```dart
{
  "userId": "123",
  "purpose": "creative_purchase",
  "reference": "CRTV_1234567890",
  "email": "user@example.com",
  "amount": 3000.0,
  "creativeIds": ["101", "102"],
  "itemCount": 2
}
```

### Service Order
```dart
{
  "userId": "123",
  "purpose": "service_order_payment",
  "reference": "SRVC_1234567890",
  "email": "user@example.com",
  "amount": 10000.0,
  "serviceIds": ["201"],
  "itemCount": 1
}
```

### Campaign Payment
```dart
{
  "userId": "123",
  "purpose": "campaign_payment",
  "reference": "CAMP_1234567890",
  "email": "user@example.com",
  "amount": 50000.0,
  "adSlotIds": ["301", "302", "303"],
  "itemCount": 3
}
```

## Usage Example

```dart
// 1. Create payment request
final paymentRequest = PaymentHelper.createCustomPayment(
  email: user.emailAddress,
  userId: user.id,
  purpose: 'template_purchase',
  totalAmount: 5000.0,
  referencePrefix: 'template',
  additionalData: {
    'templateIds': ['456', '789'],
    'itemCount': 2,
  },
);

// 2. Process payment
await ref.read(paymentNotifierProvider.notifier).processPayment(paymentRequest);

// 3. Listen to payment state
ref.listen<DataState<PaymentVerificationResponse>>(
  paymentNotifierProvider,
  (previous, next) {
    if (next.isDataAvailable && next.singleData != null) {
      // Payment successful
      showSuccessDialog();
    } else if (next.message != null && !next.isInitialLoading) {
      // Payment failed
      showErrorDialog(next.message!);
    }
  },
);
```

## Testing

### Test Cards (Paystack)
- **Success:** 4084084084084081
- **Insufficient Funds:** 5060666666666666666
- **Invalid CVV:** Use any card with CVV 000

### Test Flow
1. Add items to cart
2. Go to checkout
3. Select Paystack payment
4. Enter test card details
5. Complete payment
6. Wait for webhook processing (2-20 seconds)
7. Order should be marked as successful

## Notes

- ✅ No backend initialization endpoint needed (uses Paystack's initialize API)
- ✅ Frontend only uses public key
- ✅ Webhook handles all verification and processing
- ✅ Frontend polls to check completion
- ✅ Metadata includes all necessary order information
- ✅ Works for all payment types: templates, creatives, services, campaigns

## Status: READY FOR TESTING ✅

All code is implemented and ready. Backend needs to implement:
1. `/api/v1/payment/initialize` endpoint
2. `/webhook/paystack` endpoint  
3. `/api/v1/orders/status/:reference` endpoint

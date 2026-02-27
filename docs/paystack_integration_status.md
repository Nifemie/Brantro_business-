re# Paystack Integration Status

**Date:** February 20, 2026  
**Status:** SDK Integration - Ready for Testing

---

## Integration Method

**Using:** Paystack Flutter SDK (Native UI)  
**Package:** `paystack_flutter_sdk: ^1.0.0`

---

## Setup Completed

### ✅ 1. Package Installation
- Added `paystack_flutter_sdk: ^1.0.0` to `pubspec.yaml`
- Removed `webview_flutter` (no longer needed)

### ✅ 2. Android Configuration
- Updated `MainActivity.kt` to extend `FlutterFragmentActivity` (required by SDK)
- Location: `android/app/src/main/kotlin/com/example/brantro/MainActivity.kt`

### ✅ 3. Project Requirements Met
- Flutter >= 3.0.0 ✅
- iOS >= 13 ✅
- Android Min SDK 23, Compile SDK 34 ✅

### ✅ 4. Payment Module Updated
- `lib/features/payment/service/paystack_service.dart` - SDK integration
- `lib/features/payment/logic/payment_notifier.dart` - State management
- `lib/features/payment/data/payment_repository.dart` - API calls
- `lib/features/payment/data/models/` - Request/Response models

---

## How to Use

### 1. Initialize SDK (Once at App Startup)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro/features/payment/logic/payment_notifier.dart';

// In your main.dart or app initialization
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize Paystack SDK
    ref.read(paymentNotifierProvider.notifier).initializePaystack(
      'pk_test_xxxxx', // Your Paystack public key
    );
    
    return MaterialApp(...);
  }
}
```

### 2. Process Payment (Complete Flow)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro/features/payment/logic/payment_notifier.dart';
import 'package:brantro/features/payment/data/models/payment_request.dart';
import 'package:brantro/core/utils/reference_generator.dart';

class WalletTopupScreen extends ConsumerWidget {
  Future<void> _addMoney(WidgetRef ref, double amount) async {
    final request = PaymentRequest(
      email: 'user@example.com',
      amount: (amount * 100).toInt(), // Convert to kobo
      reference: ReferenceGenerator.generatePaymentReference('wallet'),
      currency: 'NGN',
      metadata: {'order_type': 'wallet_topup'},
      channels: ['card', 'bank', 'ussd'],
    );

    // Process payment (initialize -> launch UI -> verify)
    await ref.read(paymentNotifierProvider.notifier).processPayment(request);

    // Listen to state
    ref.listen(paymentNotifierProvider, (previous, next) {
      if (next.isDataAvailable) {
        // Payment successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment successful!')),
        );
        // Refresh wallet balance
      } else if (next.message != null) {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message!)),
        );
      }
    });
  }
}
```

### 3. Manual Flow (Step by Step)

```dart
// Step 1: Initialize payment
final accessCode = await ref
    .read(paymentNotifierProvider.notifier)
    .initializePayment(request);

if (accessCode != null) {
  // Step 2: Launch Paystack UI
  final response = await ref
      .read(paymentNotifierProvider.notifier)
      .launchPayment(accessCode);

  if (response?.status == 'success') {
    // Step 3: Verify payment
    await ref
        .read(paymentNotifierProvider.notifier)
        .verifyPayment(response!.reference);
  }
}
```

---

## Payment Flow

```
1. User clicks "Add Money"
   ↓
2. App calls processPayment() with amount
   ↓
3. SDK initializes payment on backend
   ↓
4. Backend returns access_code
   ↓
5. SDK launches native Paystack UI
   ↓
6. User completes payment
   ↓
7. SDK returns TransactionResponse
   ↓
8. App verifies payment on backend
   ↓
9. Backend credits wallet
   ↓
10. App shows success & refreshes balance
```

---

## Backend Requirements (Same as Before)

### 1. Initialize Payment
**POST** `/api/v1/payment/initialize`

**Request:**
```json
{
  "email": "user@example.com",
  "amount": 500000,
  "reference": "PAY-WALLET-1738012345678-A3F9",
  "currency": "NGN",
  "metadata": {"order_type": "wallet_topup"},
  "channels": ["card", "bank", "ussd"]
}
```

**Response:**
```json
{
  "status": true,
  "message": "Authorization URL created",
  "data": {
    "authorization_url": "https://checkout.paystack.com/abc123",
    "access_code": "abc123xyz",
    "reference": "PAY-WALLET-1738012345678-A3F9"
  }
}
```

### 2. Verify Payment
**GET** `/api/v1/payment/verify/:reference`

**Response:**
```json
{
  "status": true,
  "message": "Verification successful",
  "data": {
    "reference": "PAY-WALLET-1738012345678-A3F9",
    "status": "success",
    "amount": 5000.00,
    "currency": "NGN",
    "paid_at": "2024-01-27T10:30:00Z"
  }
}
```

---

## Error Handling

The SDK throws `PlatformException` with these error codes:

| Error Code | Description | Solution |
|------------|-------------|----------|
| `INVALID_ARGUMENT` | Missing required parameters | Check all parameters |
| `INITIALIZATION_ERROR` | SDK not initialized | Call `initializePaystack()` first |
| `UNSUPPORTED_VERSION` | OS version too old | Update device OS |
| `MISSING_VIEW` | No activity/view controller | Check MainActivity extends FlutterFragmentActivity |
| `LAUNCH_ERROR` | Payment UI failed to load | Check network & access code |

---

## Testing

### Test Cards (Paystack)
```
Success: 4084084084084081
Insufficient Funds: 5060666666666666666
```

### Test Flow
1. Run `flutter pub get`
2. Initialize SDK with test public key
3. Create payment with test amount
4. Use test card in payment UI
5. Verify payment completes
6. Check wallet balance updates

---

## Configuration Needed

### Environment Variables
```dart
// lib/core/constants/app_config.dart
class AppConfig {
  static const paystackPublicKey = String.fromEnvironment(
    'PAYSTACK_PUBLIC_KEY',
    defaultValue: 'pk_test_xxxxx', // Test key
  );
}
```

### Backend Environment
```
PAYSTACK_PUBLIC_KEY=pk_test_xxxxx
PAYSTACK_SECRET_KEY=sk_test_xxxxx
```

---

## Next Steps

1. ✅ Run `flutter pub get`
2. ✅ Test on Android device (MainActivity updated)
3. ✅ Test on iOS device
4. ✅ Create "Add Money" screen
5. ✅ Integrate with wallet
6. ✅ Test end-to-end flow
7. ✅ Switch to live keys for production

---

## Advantages of SDK over WebView

✅ Native UI (better UX)  
✅ Faster performance  
✅ Better error handling  
✅ Automatic session management  
✅ No WebView dependencies  
✅ Smaller app size  
✅ Better security  

---

**Status:** Ready for implementation and testing  
**Last Updated:** February 20, 2026


### 1. Payment Initialization Endpoint
**Endpoint:** `POST /api/v1/payment/initialize`

**Request:**
```http
POST /api/v1/payment/initialize
Authorization: Bearer <user_access_token>
Content-Type: application/json

{
  "email": "user@example.com",
  "amount": 500000,
  "reference": "PAY-WALLET-1738012345678-A3F9",
  "currency": "NGN",
  "metadata": {
    "order_type": "wallet_topup"
  },
  "channels": ["card", "bank", "ussd", "qr", "mobile_money", "bank_transfer"]
}
```

**Expected Response:**
```json
{
  "status": true,
  "message": "Authorization URL created",
  "data": {
    "authorization_url": "https://checkout.paystack.com/abc123xyz",
    "access_code": "abc123xyz",
    "reference": "PAY-WALLET-1738012345678-A3F9"
  }
}
```

**Backend Must:**
- Extract `user_id` from Bearer token (NOT from request body)
- Call Paystack API to initialize payment
- Store payment reference linked to user
- Return `authorization_url` for WebView

---

### 2. Payment Verification Endpoint
**Endpoint:** `GET /api/v1/payment/verify/:reference`

**Request:**
```http
GET /api/v1/payment/verify/PAY-WALLET-1738012345678-A3F9
Authorization: Bearer <user_access_token>
```

**Expected Response:**
```json
{
  "status": true,
  "message": "Verification successful",
  "data": {
    "id": 123456,
    "reference": "PAY-WALLET-1738012345678-A3F9",
    "status": "success",
    "amount": 5000.00,
    "currency": "NGN",
    "paid_at": "2024-01-27T10:30:00Z",
    "channel": "card",
    "metadata": {
      "order_type": "wallet_topup"
    },
    "customer": {
      "id": 789,
      "email": "user@example.com"
    }
  }
}
```

**Backend Must:**
- Extract `user_id` from Bearer token
- Verify payment with Paystack API directly
- Check if payment already processed (prevent double-crediting)
- If status = "success", credit user's wallet
- Create transaction record
- Return verification result

---

### 3. Payment Status Endpoint
**Endpoint:** `GET /api/v1/payment/status/:reference`

**Request:**
```http
GET /api/v1/payment/status/PAY-WALLET-1738012345678-A3F9
Authorization: Bearer <user_access_token>
```

**Expected Response:**
```json
{
  "status": true,
  "message": "Payment status retrieved",
  "data": {
    "reference": "PAY-WALLET-1738012345678-A3F9",
    "status": "success",
    "amount": 5000.00,
    "paid_at": "2024-01-27T10:30:00Z"
  }
}
```

---

## Payment Flow

```
1. User clicks "Add Money" in Wallet
   ↓
2. Frontend calls POST /api/v1/payment/initialize
   ↓
3. Backend returns authorization_url
   ↓
4. Frontend opens WebView with authorization_url
   ↓
5. User completes payment on Paystack
   ↓
6. Paystack redirects back
   ↓
7. Frontend calls GET /api/v1/payment/verify/:reference
   ↓
8. Backend verifies with Paystack & credits wallet
   ↓
9. Frontend shows success message & refreshes wallet
```

---

## Security Requirements

Backend MUST implement:
- ✅ Extract user_id from Bearer token (never trust request body)
- ✅ Verify all payments with Paystack API directly
- ✅ Prevent duplicate transactions (check reference uniqueness)
- ✅ Validate amount matches initialization
- ✅ Use HTTPS for all API calls
- ✅ Log all payment attempts
- ✅ Implement idempotency (same reference = same result)

---

## Paystack Configuration Needed

Backend team needs:
1. **Paystack API Keys:**
   - Test Public Key: `pk_test_xxxxx`
   - Test Secret Key: `sk_test_xxxxx`
   - Live Public Key: `pk_live_xxxxx`
   - Live Secret Key: `sk_live_xxxxx`

2. **Webhook Setup (Optional but Recommended):**
   - Webhook URL: `https://api.syroltech.com/brantro/api/v1/payment/webhook`
   - Webhook Secret: `whsec_xxxxx`

3. **Environment Variables:**
   ```
   PAYSTACK_PUBLIC_KEY=pk_test_xxxxx
   PAYSTACK_SECRET_KEY=sk_test_xxxxx
   PAYSTACK_WEBHOOK_SECRET=whsec_xxxxx
   ```

---

## Next Steps

### For Backend Team:
1. ✅ Get Paystack API keys (test & live)
2. ✅ Implement 3 endpoints listed above
3. ✅ Set up Paystack webhook (optional)
4. ✅ Test with Paystack test cards
5. ✅ Notify frontend when ready

### For Frontend Team (After Backend Ready):
1. Create "Add Money" screen in wallet
2. Integrate PaymentButton widget
3. Test payment flow end-to-end
4. Handle success/failure scenarios
5. Update wallet balance after payment

---

## Important Notes

### Amount Conversion:
- Frontend sends amount in **kobo** (₦5,000 = 500000 kobo)
- Backend stores/returns amount in **Naira** (5000.00)
- Conversion: `kobo = naira * 100`

### User Identification:
- User is identified by **Bearer token** in headers
- Backend extracts `user_id` from token
- Never send `user_id` in request body (security risk)

### Payment Reference:
- Format: `PAY-WALLET-{timestamp}-{random}`
- Example: `PAY-WALLET-1738012345678-A3F9`
- Must be unique per transaction
- Generated by frontend using `ReferenceGenerator.generatePaymentReference('wallet')`

---

## Testing Checklist

### Backend Testing:
- [ ] Initialize payment returns authorization_url
- [ ] Verify endpoint credits wallet on success
- [ ] Duplicate verification doesn't double-credit
- [ ] Failed payments don't credit wallet
- [ ] Status endpoint returns correct status
- [ ] Bearer token authentication works
- [ ] Invalid reference returns error

### Frontend Testing:
- [ ] Payment button opens WebView
- [ ] WebView loads Paystack page
- [ ] Payment success redirects correctly
- [ ] Wallet balance updates after payment
- [ ] Transaction appears in history
- [ ] Error handling works
- [ ] Loading states display correctly

---

## Contact

**Frontend Lead:** [Your Name]  
**Backend Lead:** [Backend Team Lead]  
**Date Started:** February 9, 2026  
**Target Completion:** [TBD]

---

## References

- Paystack Documentation: https://paystack.com/docs
- Frontend Payment Module: `lib/features/payment/`
- Backend API Base: `https://api.syroltech.com/brantro/api/v1`

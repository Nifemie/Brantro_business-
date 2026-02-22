# Template Payment Integration - Complete

## What We Implemented

Integrated Paystack payment for template purchases in the checkout screen. When user selects "Paystack" payment method and clicks "Confirm & Pay", the Paystack SDK opens for payment.

## Flow

```
1. User adds templates to cart
   ↓
2. User goes to checkout
   ↓
3. User selects "Paystack" payment method
   ↓
4. User clicks "Confirm & Pay"
   ↓
5. Paystack SDK opens (card entry UI)
   ↓
6. User enters card details and pays
   ↓
7. Paystack processes payment
   ↓
8. Paystack sends webhook to backend
   POST /webhooks/paystack/template-order
   ↓
9. Frontend polls backend for order status
   GET /api/v1/orders/status/:reference
   ↓
10. Backend returns order processed
   ↓
11. Frontend shows success modal
   ↓
12. Cart is cleared
```

## Code Changes

### checkout_screen.dart

**Added imports:**
```dart
import '../../../payment/logic/payment_notifier.dart';
import '../../../payment/utils/payment_helper.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/data/data_state.dart';
```

**Modified `_handlePayment()` method:**
- Checks if payment method is 'paystack'
- If yes, calls `_handlePaystackPayment()`
- If no, continues with wallet payment

**Added `_handlePaystackPayment()` method:**
- Gets user from userProvider
- Generates payment reference
- Builds metadata with template IDs
- Creates PaymentRequest with PaymentHelper
- Calls payment notifier to process payment
- Listens for payment result
- Shows success/error messages
- Clears cart on success

## Payment Metadata Structure

For template purchases:
```json
{
  "userId": 123,
  "purpose": "template_purchase",
  "reference": "PAY-TEMPLATE-1234567890-ABC",
  "email": "user@example.com",
  "amount": 50000.00,
  "templateIds": ["TPL-001", "TPL-002"],
  "itemCount": 2
}
```

## Backend Requirements

### 1. Webhook Endpoint
```
POST /webhooks/paystack/template-order
```

Receives payment data from Paystack and processes template order.

### 2. Order Status Endpoint
```
GET /api/v1/orders/status/:reference
```

Returns order processing status for frontend polling.

## Testing

1. Add templates to cart
2. Go to checkout
3. Select "Paystack" payment method
4. Click "Confirm & Pay"
5. Paystack SDK should open
6. Use test card: 4084084084084081
7. Complete payment
8. Frontend polls for order status
9. Success modal appears
10. Cart is cleared

## Next Steps

Apply same pattern to:
- ✅ Template purchase (DONE)
- ⏳ Creative purchase
- ⏳ Service order
- ⏳ Campaign payment
- ⏳ Wallet top-up

## Notes

- Payment reference is auto-generated
- Metadata includes all template IDs
- Frontend polls every 2 seconds for up to 20 seconds
- Webhook processes order in background
- User sees success when webhook completes

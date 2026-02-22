# Paystack Payment Integration

This module handles payment processing using Paystack for the Brantro app.

## Structure

```
payment/
├── data/
│   ├── models/
│   │   ├── payment_request.dart          # Payment initialization request model
│   │   ├── payment_response.dart         # Payment initialization response model
│   │   └── payment_verification_response.dart  # Payment verification response model
│   └── payment_repository.dart           # API calls for payment operations
├── logic/
│   └── payment_notifier.dart             # State management for payments
├── presentation/
│   ├── payment_webview_screen.dart       # WebView screen for payment UI
│   └── widgets/
│       └── payment_button.dart           # Reusable payment button widget
├── service/
│   └── paystack_service.dart             # High-level payment service
└── README.md
```

## Features

- **Payment Initialization**: Create payment transactions with Paystack
- **Payment Verification**: Verify payment status after completion
- **WebView Integration**: Seamless in-app payment experience
- **Multiple Payment Channels**: Card, Bank Transfer, USSD, QR, Mobile Money
- **Metadata Support**: Attach custom data to transactions
- **Error Handling**: Comprehensive error handling and user feedback

## Usage

### 1. Using PaymentButton Widget (Recommended)

```dart
import 'package:brantro/features/payment/presentation/widgets/payment_button.dart';

PaymentButton(
  amount: 5000.00,
  orderType: 'campaign',
  metadata: {
    'campaign_id': '123',
    'user_id': '456',
  },
  onSuccess: () {
    // Handle successful payment
    print('Payment successful!');
  },
  onCancel: () {
    // Handle cancelled payment
    print('Payment cancelled');
  },
  buttonText: 'Pay Now',
  isEnabled: true,
)
```

### 2. Using PaystackService Directly

```dart
import 'package:brantro/features/payment/service/paystack_service.dart';

final paystackService = PaystackService(paymentRepository);

// Initialize payment
final response = await paystackService.initializePayment(
  email: 'user@example.com',
  amount: 5000.00,
  reference: 'PAY-CAMPAIGN-1234567890-ABCD',
  metadata: {'order_type': 'campaign'},
);

// Verify payment
final verification = await paystackService.verifyPayment(reference);

if (verification?.data?.isSuccessful ?? false) {
  print('Payment successful!');
}
```

### 3. Using PaymentNotifier (State Management)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brantro/features/payment/logic/payment_notifier.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentNotifierProvider);
    
    return ElevatedButton(
      onPressed: () async {
        final request = PaymentRequest(
          email: 'user@example.com',
          amount: 5000.00,
          reference: 'PAY-123',
        );
        
        final success = await ref
            .read(paymentNotifierProvider.notifier)
            .initializePayment(request);
            
        if (success) {
          // Navigate to payment webview
        }
      },
      child: paymentState.isLoading 
          ? CircularProgressIndicator()
          : Text('Pay Now'),
    );
  }
}
```

## API Endpoints

The payment module expects the following backend endpoints:

- `POST /payment/initialize` - Initialize a payment transaction
- `GET /payment/verify/:reference` - Verify a payment transaction
- `GET /payment/status/:reference` - Get payment status

## Models

### PaymentRequest
```dart
{
  "email": "user@example.com",
  "amount": 500000,  // Amount in kobo (₦5,000.00)
  "reference": "PAY-CAMPAIGN-1234567890-ABCD",
  "currency": "NGN",
  "metadata": {
    "order_type": "campaign",
    "campaign_id": "123"
  },
  "channels": ["card", "bank", "ussd"]
}
```

### PaymentResponse
```dart
{
  "status": true,
  "message": "Authorization URL created",
  "data": {
    "authorization_url": "https://checkout.paystack.com/...",
    "access_code": "abc123",
    "reference": "PAY-CAMPAIGN-1234567890-ABCD"
  }
}
```

### PaymentVerificationResponse
```dart
{
  "status": true,
  "message": "Verification successful",
  "data": {
    "id": 123456,
    "reference": "PAY-CAMPAIGN-1234567890-ABCD",
    "status": "success",
    "amount": 5000.00,
    "currency": "NGN",
    "paid_at": "2024-01-27T10:30:00Z",
    "channel": "card",
    "metadata": {...},
    "customer": {
      "id": 789,
      "email": "user@example.com"
    }
  }
}
```

## Payment Flow

1. User clicks payment button
2. App generates unique payment reference
3. App calls `/payment/initialize` with payment details
4. Backend returns authorization URL
5. App opens WebView with authorization URL
6. User completes payment on Paystack
7. Paystack redirects to callback URL
8. App detects redirect and calls `/payment/verify`
9. Backend verifies payment with Paystack
10. App shows success/failure message

## Reference Generation

Payment references are generated using the `ReferenceGenerator` utility:

```dart
final reference = ReferenceGenerator.generatePaymentReference('campaign');
// Output: PAY-CAMPAIGN-1738012345678-A3F9
```

## Error Handling

The module handles various error scenarios:

- Network errors
- Payment initialization failures
- Payment verification failures
- User cancellation
- Timeout errors

Errors are displayed to users via dialogs and can be accessed through the `PaymentState.error` property.

## Testing

To test payment integration:

1. Use Paystack test keys in development
2. Use test card numbers provided by Paystack
3. Test various payment scenarios (success, failure, cancellation)
4. Verify payment verification works correctly

## Dependencies

- `webview_flutter: ^4.10.0` - For in-app payment UI
- `flutter_riverpod: ^2.5.1` - State management
- `dio: ^5.9.0` - HTTP client
- `go_router: ^14.2.0` - Navigation

## Notes

- All amounts are handled in Naira (NGN) and converted to kobo for Paystack
- Payment references must be unique for each transaction
- Metadata can be used to attach order information to payments
- The WebView automatically handles payment completion and verification

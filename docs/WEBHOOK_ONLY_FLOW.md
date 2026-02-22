# Webhook-Only Payment Flow

## Overview

Using Paystack webhooks is the **recommended approach**. Paystack automatically notifies your backend when payment succeeds, and frontend just polls to check when processing is complete.

## The Complete Flow

```
1. User clicks "Pay" in app
   ↓
2. Frontend charges card with Paystack SDK (public key)
   ↓
3. User enters card details and completes payment
   ↓
4. Paystack sends webhook to backend automatically
   POST /webhooks/paystack/template-order
   {
     "event": "charge.success",
     "data": {
       "reference": "PAY-CAMPAIGN-123-ABC",
       "amount": 5000000,
       "currency": "NGN",
       "status": "success",
       "metadata": {
         "userId": 123,
         "purpose": "campaign_payment",
         "campaignId": 456,
         ...
       }
     }
   }
   ↓
5. Backend processes order (creates campaign, credits wallet, etc)
   ↓
6. Frontend polls backend to check if order is complete
   GET /api/v1/orders/status/:reference
   ↓
7. Backend returns order status
   {
     "status": true,
     "data": {
       "reference": "PAY-CAMPAIGN-123-ABC",
       "processed": true,
       "orderId": 789,
       "status": "completed"
     }
   }
   ↓
8. Frontend shows success message
```

## Frontend Implementation

### 1. Charge Card

```dart
final paymentRequest = PaymentHelper.createCampaignPayment(
  email: user.email,
  userId: user.id,
  totalAmount: 50000.00,
  campaignId: campaign.id,
);

// Process payment (charges + polls for completion)
await ref.read(paymentNotifierProvider.notifier).processPayment(paymentRequest);
```

### 2. Handle Result

```dart
ref.listen(paymentNotifierProvider, (previous, next) {
  if (next.isDataAvailable) {
    // Payment successful and order processed!
    showSuccessMessage();
    navigateToCampaigns();
  } else if (next.message != null) {
    // Payment failed or timeout
    showError(next.message);
  }
});
```

## Backend Requirements

### 1. Webhook Endpoint

```javascript
POST /webhooks/paystack/template-order
POST /webhooks/paystack/campaign-payment
POST /webhooks/paystack/creative-purchase
// etc. for each payment type
```

**What it receives from Paystack:**
```javascript
{
  "event": "charge.success",
  "data": {
    "reference": "PAY-CAMPAIGN-123-ABC",
    "amount": 5000000, // kobo
    "currency": "NGN",
    "status": "success",
    "paid_at": "2024-01-27T10:30:00Z",
    "channel": "card",
    "metadata": {
      "userId": 123,
      "purpose": "campaign_payment",
      "reference": "PAY-CAMPAIGN-123-ABC",
      "email": "user@example.com",
      "amount": 50000.00,
      "campaignId": 456
    }
  }
}
```

**What it should do:**
1. Verify webhook signature (security)
2. Check if already processed (idempotency)
3. Process based on metadata.purpose:
   - `campaign_payment` → Create campaign
   - `creative_purchase` → Grant access to creative
   - `service_order_payment` → Create service order
   - `template_purchase` → Grant access to template
   - `wallet_topup` → Credit wallet
4. Mark order as processed
5. Return 200 OK to Paystack

### 2. Order Status Endpoint

```javascript
GET /api/v1/orders/status/:reference
Authorization: Bearer <token>
```

**What it returns:**
```javascript
{
  "status": true,
  "data": {
    "reference": "PAY-CAMPAIGN-123-ABC",
    "processed": true,
    "orderId": 789,
    "status": "completed",
    "amount": 50000.00,
    "createdAt": "2024-01-27T10:30:00Z"
  }
}
```

## Webhook Security

### Verify Paystack Signature

```javascript
const crypto = require('crypto');

function verifyPaystackSignature(req) {
  const hash = crypto
    .createHmac('sha512', process.env.PAYSTACK_SECRET_KEY)
    .update(JSON.stringify(req.body))
    .digest('hex');
    
  return hash === req.headers['x-paystack-signature'];
}

// In webhook handler
if (!verifyPaystackSignature(req)) {
  return res.status(400).json({ error: 'Invalid signature' });
}
```

## Polling Configuration

Frontend polls every 2 seconds for up to 10 attempts (20 seconds total):

```dart
// In PaystackService.processPayment()
maxPollingAttempts: 10,
pollingInterval: Duration(seconds: 2),
```

You can adjust these values if needed.

## Error Handling

### Timeout
If webhook takes longer than 20 seconds:
- Frontend shows: "Payment successful but order processing is taking longer than expected"
- User can check their orders later
- Webhook will still process in background

### Webhook Failure
If webhook fails:
- Paystack retries automatically (up to 3 times)
- Backend should handle idempotency
- Frontend timeout will trigger

### Network Issues
If polling fails:
- Frontend shows error
- User can manually refresh orders
- Order will still be processed by webhook

## Advantages of Webhook-Only

✅ **More Reliable**: Paystack retries if webhook fails
✅ **Simpler Frontend**: No need to call verify endpoint
✅ **Better UX**: Works even if user closes app
✅ **Scalable**: Backend controls all processing
✅ **Secure**: No sensitive operations in frontend

## Testing

### Test Webhook Locally

Use ngrok to expose local server:
```bash
ngrok http 3000
```

Configure webhook URL in Paystack dashboard:
```
https://your-ngrok-url.ngrok.io/webhooks/paystack/template-order
```

### Test Cards

| Card Number | Result |
|-------------|--------|
| 4084084084084081 | Success |
| 5060666666666666666 | Insufficient Funds |

## Summary

**Frontend:**
1. Charges card with Paystack SDK
2. Polls backend to check if order is processed
3. Shows success when order is ready

**Backend:**
1. Receives webhook from Paystack
2. Processes order based on metadata.purpose
3. Returns order status when frontend polls

**No verify endpoint needed!** Webhook handles everything automatically.

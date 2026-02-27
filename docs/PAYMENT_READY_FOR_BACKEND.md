# Payment Integration Complete - Backend Requirements

## Status: ✅ FRONTEND READY

The Paystack payment integration is complete on the frontend. The app is ready to process payments once the backend endpoints are implemented.

## What We Built

### Webhook-Only Payment Flow
As you requested, we implemented a webhook-only flow where:
1. Frontend gets access code from backend
2. Frontend charges card with Paystack SDK (using public key only)
3. Paystack sends webhook to backend automatically
4. Frontend polls backend to check if order is processed

### Supported Payment Types
- ✅ Template purchases
- ✅ Creative purchases  
- ✅ Service orders
- ✅ Campaign payments
- ✅ Wallet top-ups (ready for implementation)

## Backend Endpoints Needed

### 1. Initialize Transaction
```
POST /api/v1/payment/initialize

Request Body:
{
  "email": "user@example.com",
  "amount": 500000,  // in kobo
  "reference": "TEMP_1234567890",
  "currency": "NGN",
  "metadata": {
    "userId": "123",
    "purpose": "template_purchase",
    "templateIds": ["456", "789"],
    "itemCount": 2
  }
}

Response:
{
  "status": true,
  "data": {
    "access_code": "67joTry7t1jz2o",
    "reference": "TEMP_1234567890"
  }
}
```

**What it does:**
- Calls Paystack API: `POST https://api.paystack.co/transaction/initialize`
- Uses secret key: `sk_test_19fc108601a2d08f8013fef2237c82216223b395`
- Returns access_code to frontend

### 2. Webhook Handler
```
POST /webhook/paystack

Paystack sends:
{
  "event": "charge.success",
  "data": {
    "reference": "TEMP_1234567890",
    "amount": 500000,
    "status": "success",
    "customer": { "email": "user@example.com" },
    "metadata": {
      "userId": "123",
      "purpose": "template_purchase",
      "templateIds": ["456", "789"]
    }
  }
}
```

**What it does:**
1. Verify webhook signature (security)
2. Verify transaction with Paystack API
3. Process order based on `purpose`:
   - `template_purchase`: Create purchased templates
   - `creative_purchase`: Create purchased creatives
   - `service_order_payment`: Create service order
   - `campaign_payment`: Create campaign with ad slots
4. Mark order as `processed: true`

### 3. Order Status Check
```
GET /api/v1/orders/status/:reference

Response:
{
  "status": true,
  "data": {
    "reference": "TEMP_1234567890",
    "processed": true,
    "status": "success",
    "amount": 5000.0,
    "currency": "NGN",
    "paidAt": "2025-02-20T10:30:00Z",
    "channel": "card"
  }
}
```

**What it does:**
- Returns order processing status
- Frontend polls this every 2 seconds (max 10 attempts)

## Payment Metadata by Purpose

### template_purchase
```json
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

### creative_purchase
```json
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

### service_order_payment
```json
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

### campaign_payment
```json
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

## Paystack API Reference

### Initialize Transaction
```bash
curl https://api.paystack.co/transaction/initialize \
  -H "Authorization: Bearer sk_test_19fc108601a2d08f8013fef2237c82216223b395" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "amount": "500000",
    "reference": "TEMP_1234567890",
    "metadata": { ... }
  }'
```

### Verify Transaction
```bash
curl https://api.paystack.co/transaction/verify/TEMP_1234567890 \
  -H "Authorization: Bearer sk_test_19fc108601a2d08f8013fef2237c82216223b395"
```

### Webhook Setup
Go to Paystack Dashboard → Settings → Webhooks
- URL: `https://api.syroltech.com/brantro/webhook/paystack`
- Events: `charge.success`

## Testing

### Test Cards
- **Success:** 4084084084084081
- **Insufficient Funds:** 5060666666666666666

### Test Flow
1. User adds items to cart
2. User goes to checkout
3. User clicks "Pay with Paystack"
4. Frontend calls `/api/v1/payment/initialize`
5. Frontend launches Paystack UI with access_code
6. User enters card details
7. Paystack processes payment
8. Paystack sends webhook to backend
9. Backend processes order
10. Frontend polls `/api/v1/orders/status/:reference`
11. Frontend shows success message

## What's Already Done ✅

- ✅ Paystack SDK integrated
- ✅ Payment service implemented
- ✅ Payment notifier with state management
- ✅ Checkout screens for all payment types
- ✅ Payment metadata structure
- ✅ Reference generation
- ✅ Polling mechanism
- ✅ Error handling
- ✅ Success/failure UI

## Next Steps

1. **Backend Team:** Implement the 3 endpoints above
2. **Backend Team:** Set up webhook URL in Paystack dashboard
3. **Testing:** Test with Paystack test cards
4. **Production:** Switch to live keys when ready

## Questions?

Check these docs:
- `docs/PAYSTACK_FINAL_IMPLEMENTATION.md` - Complete technical details
- `docs/WEBHOOK_ONLY_FLOW.md` - Flow diagram
- `docs/BACKEND_REQUIREMENTS.md` - Backend specifications

## Contact

Frontend implementation is complete. Ready for backend integration! 🚀

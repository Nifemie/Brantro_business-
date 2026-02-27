# Backend Requirements for Payment Integration

## Summary

Frontend is **ready** and will send payments with the correct metadata structure. Backend only needs **ONE endpoint** to verify and process payments.

---

## What Frontend Sends

When user pays, frontend charges Paystack directly with this structure:

```javascript
{
  email: "user@example.com",
  reference: "PAY-CAMPAIGN-1234567890-ABC",
  amountKobo: 5000000, // ₦50,000 in kobo
  metadata: {
    userId: 123,
    purpose: "campaign_payment", // or creative_purchase, service_order_payment, template_purchase, wallet_topup
    reference: "PAY-CAMPAIGN-1234567890-ABC",
    email: "user@example.com",
    amount: 50000.00,
    // Additional data based on purpose:
    campaignId: 456,        // for campaign_payment
    creativeId: 789,        // for creative_purchase
    serviceId: 101,         // for service_order_payment
    templateId: 202,        // for template_purchase
    // etc.
  }
}
```

---

## What Backend Needs to Do

### 1. Implement ONE Endpoint

```
GET /api/v1/payment/verify/:reference
Authorization: Bearer <token>
```

### 2. Endpoint Logic

```javascript
async function verifyPayment(req, res) {
  const { reference } = req.params;
  const userId = req.user.id; // From Bearer token
  
  try {
    // Step 1: Verify with Paystack API
    const paystackResponse = await axios.get(
      `https://api.paystack.co/transaction/verify/${reference}`,
      {
        headers: {
          Authorization: `Bearer ${process.env.PAYSTACK_SECRET_KEY}`
        }
      }
    );
    
    const paymentData = paystackResponse.data.data;
    const { status, amount, metadata, paid_at, channel } = paymentData;
    
    // Step 2: Check if already processed (prevent double-crediting)
    const existingPayment = await db.payments.findOne({ reference });
    if (existingPayment) {
      return res.json({
        status: true,
        message: 'Payment already processed',
        data: existingPayment
      });
    }
    
    // Step 3: Only process successful payments
    if (status !== 'success') {
      return res.json({
        status: false,
        message: 'Payment not successful',
        data: { status, reference }
      });
    }
    
    // Step 4: Process based on purpose
    const { purpose } = metadata;
    
    switch (purpose) {
      case 'campaign_payment':
        await createCampaign(userId, metadata.campaignId, metadata);
        break;
        
      case 'creative_purchase':
        await purchaseCreative(userId, metadata.creativeId);
        break;
        
      case 'service_order_payment':
        await createServiceOrder(userId, metadata.serviceId, metadata);
        break;
        
      case 'template_purchase':
        await purchaseTemplate(userId, metadata.templateId);
        break;
        
      case 'wallet_topup':
        await creditWallet(userId, amount / 100); // Convert kobo to Naira
        break;
        
      default:
        throw new Error(`Unknown payment purpose: ${purpose}`);
    }
    
    // Step 5: Save transaction record
    const transaction = await db.payments.create({
      reference,
      userId,
      amount: amount / 100, // Convert kobo to Naira
      status: 'success',
      channel,
      paidAt: paid_at,
      metadata,
      createdAt: new Date()
    });
    
    // Step 6: Return success response
    return res.json({
      status: true,
      message: 'Payment verified successfully',
      data: {
        id: transaction.id,
        reference: transaction.reference,
        status: transaction.status,
        amount: transaction.amount,
        currency: 'NGN',
        paid_at: transaction.paidAt,
        channel: transaction.channel,
        metadata: transaction.metadata
      }
    });
    
  } catch (error) {
    console.error('Payment verification error:', error);
    return res.status(500).json({
      status: false,
      message: 'Payment verification failed',
      error: error.message
    });
  }
}
```

---

## Payment Purposes

Frontend will send these purposes:

| Purpose | Description | Additional Metadata |
|---------|-------------|---------------------|
| `campaign_payment` | User creates ad campaign | `campaignId`, `campaignName` |
| `creative_purchase` | User buys creative asset | `creativeId`, `creativeName` |
| `service_order_payment` | User orders service | `serviceId`, `serviceName`, `orderId` |
| `template_purchase` | User buys template | `templateId`, `templateName` |
| `ad_slot_booking` | User books ad slot | `adSlotId`, `adSlotName`, `startDate`, `endDate` |
| `wallet_topup` | User adds money to wallet | (none) |

---

## Environment Variables Needed

```bash
# .env file
PAYSTACK_SECRET_KEY=sk_test_19fc108601a2d08f8013fef2237c82216223b395
```

**IMPORTANT:** Never expose this key in frontend or commit to git!

---

## Database Schema

### payments table

```sql
CREATE TABLE payments (
  id SERIAL PRIMARY KEY,
  reference VARCHAR(255) UNIQUE NOT NULL,
  user_id INTEGER NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) NOT NULL,
  channel VARCHAR(50),
  paid_at TIMESTAMP,
  metadata JSONB,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_payments_reference ON payments(reference);
CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);
```

---

## Testing

### Test with Postman

```bash
GET http://localhost:3000/api/v1/payment/verify/PAY-TEST-1234567890-ABC
Authorization: Bearer <your_test_token>
```

### Expected Response

```json
{
  "status": true,
  "message": "Payment verified successfully",
  "data": {
    "id": 123,
    "reference": "PAY-CAMPAIGN-1234567890-ABC",
    "status": "success",
    "amount": 50000.00,
    "currency": "NGN",
    "paid_at": "2024-01-27T10:30:00Z",
    "channel": "card",
    "metadata": {
      "userId": 123,
      "purpose": "campaign_payment",
      "reference": "PAY-CAMPAIGN-1234567890-ABC",
      "email": "user@example.com",
      "amount": 50000.00,
      "campaignId": 456
    }
  }
}
```

---

## Important Notes

1. **Idempotency**: Always check if payment already processed before crediting
2. **Amount Conversion**: Paystack returns amount in kobo, convert to Naira (÷ 100)
3. **Metadata**: All payment context is in metadata - use it to process correctly
4. **Error Handling**: Return proper error messages for failed verifications
5. **Logging**: Log all payment attempts for debugging and auditing

---

## What Frontend Does

1. ✅ User clicks "Pay"
2. ✅ Frontend generates unique reference
3. ✅ Frontend charges card with Paystack SDK (public key)
4. ✅ User completes payment
5. ✅ Frontend calls your verify endpoint
6. ⏳ Backend verifies and processes (YOUR PART)
7. ✅ Frontend shows success/error message

---

## Summary

**You only need:**
- ✅ One endpoint: `GET /api/v1/payment/verify/:reference`
- ✅ Paystack secret key in environment
- ✅ Logic to process based on `metadata.purpose`
- ✅ Database to store transaction records

**Frontend handles:**
- ✅ Charging cards with Paystack
- ✅ Generating references
- ✅ Sending correct metadata
- ✅ Calling your verify endpoint

---

## Questions?

If you need clarification on:
- Metadata structure for specific payment types
- How to process each payment purpose
- Database schema
- Error handling

Let me know!

/// Paystack Configuration
/// Contains API keys and configuration for Paystack payment integration
class PaystackConfig {
  // Test Keys
  static const String testPublicKey = 'pk_test_eb8e97936668538460a30817a607f75816ce35b2';
  static const String testSecretKey = 'sk_test_19fc108601a2d08f8013fef2237c82216223b395';

  // Live Keys (to be added when going to production)
  static const String livePublicKey = 'pk_live_xxxxx'; // Replace with live key
  static const String liveSecretKey = 'sk_live_xxxxx'; // Replace with live key

  // Environment flag
  static const bool isProduction = false; // Set to true for production

  // Get current public key based on environment
  static String get publicKey => isProduction ? livePublicKey : testPublicKey;

  // Get current secret key based on environment (backend only)
  static String get secretKey => isProduction ? liveSecretKey : testSecretKey;
}

/// Payment Purpose Types
/// These are used in metadata to identify the type of payment
class PaymentPurpose {
  static const String walletTopup = 'wallet_topup';
  static const String campaignPayment = 'campaign_payment';
  static const String creativePurchase = 'creative_purchase';
  static const String serviceOrderPayment = 'service_order_payment';
  static const String templatePurchase = 'template_purchase';
  static const String adSlotBooking = 'ad_slot_booking';
}

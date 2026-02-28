class ApiEndpoints {
  // Base API version
  static const String apiVersion = '/api/v1';

  // Auth Endpoints
  static const String signup = '$apiVersion/user/signup';
  static const String validateAccount = '$apiVersion/user/validate-account';
  static const String verifyAccount = '$apiVersion/user/verify-account';
  static const String login = '$apiVersion/auth/login';
  static const String forgotPassword = '$apiVersion/user/forgot-password';
  static const String resetPassword = '$apiVersion/user/reset-password';

  // Creator Endpoints
  static const String usersList = '$apiVersion/user/list';
  static const String searchUsers = '$apiVersion/user/search';

  // Location Endpoints
  static const String locationsList = '$apiVersion/location/list';

  // Ad Slots Endpoints
  static const String adSlotsList = '$apiVersion/adslots/list';
  static const String searchAdSlots = '$apiVersion/adslots/search';
  static const String createAdSlot = '$apiVersion/adslots';
  static const String adSlotsDetails = '$apiVersion/adslots/details'; // + /:id

  // KYC Endpoints
  static const String kycInitiate = '$apiVersion/kyc/initiate';
  static const String kycStatus = '$apiVersion/kyc/status';
  static const String kycSubmit = '$apiVersion/kyc/submit';
  static const String kycVerifyOtp = '$apiVersion/kyc/verify-otp';
  static const String kycFace = '$apiVersion/kyc/face';

  // Contact/Message Endpoints
  static const String sendMessage = '$apiVersion/message';

  // Digital Services Endpoints
  static const String servicesList = '$apiVersion/service/list';
  static const String serviceDetails = '$apiVersion/service/details'; // + /:id
  static const String searchServices = '$apiVersion/service/search';

  // Wallet Endpoints
  static const String walletMe = '$apiVersion/wallet/me';
  static const String walletTransactions = '$apiVersion/wallet/transactions/list';

  // Vetting Endpoints
  static const String vettingList = '$apiVersion/vetting/list';
  static const String vettingDetails = '$apiVersion/vetting/details'; // + /:id

  // Template Endpoints
  static const String templateList = '$apiVersion/template/list';
  static const String templateDetails = '$apiVersion/template/details'; // + /:id
  static const String templateOrder = '$apiVersion/template-order';
  static const String myTemplates = '$apiVersion/template-order/mine';

  // Creative Endpoints
  static const String creativesList = '$apiVersion/creative/list';
  static const String creativeDetails = '$apiVersion/creative/details'; // + /:id
  static const String creativeOrder = '$apiVersion/creative-order';
  static const String myCreatives = '$apiVersion/creative-order/mine';
  
  // Service Order Endpoint
  static const String serviceOrder = '$apiVersion/service-order';
  static const String myServices = '$apiVersion/service-order/mine';
  static String updateServiceRequirements(int itemId) => '$apiVersion/service-order/items/$itemId/requirements';
  static String cancelServiceOrder(int itemId) => '$apiVersion/service-order/items/$itemId/cancel';
  
  // Campaign Order Endpoint
  static const String campaignOrder = '$apiVersion/ad-campaign';
  
  // My Campaigns Endpoint
  static const String myCampaigns = '$apiVersion/ad-campaign/mine';
  
  // Campaign Details Endpoint
  static const String campaignDetails = '$apiVersion/ad-campaign/details'; // + /:id
  
  // Cancel Campaign Endpoint
  static String cancelCampaign(int campaignId) => '$apiVersion/ad-campaign/$campaignId/cancel';
  
  // Payment Endpoints
  static const String paymentInitialize = '$apiVersion/payment/initialize';
  static const String paymentVerify = '$apiVersion/payment/verify'; // + /:reference
  static const String paymentStatus = '$apiVersion/payment/status'; // + /:reference
}

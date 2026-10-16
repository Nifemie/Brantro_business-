class ApiEndpoints {
  // Base API version
  static const String apiVersion = 'api/v1';

  // Auth Endpoints
  static const String signup = '$apiVersion/user/signup';
  static const String validateAccount = '$apiVersion/user/validate-account';
  static const String verifyAccount = '$apiVersion/user/verify-account';
  static const String login = '$apiVersion/auth/login';
  static const String forgotPassword = '$apiVersion/user/forgot-password';
  static const String resetPassword = '$apiVersion/user/reset-password';

  // Orders Endpoints
  static const String creativeOrdersList = '$apiVersion/creative-order/list';
  static const String templateOrdersList = '$apiVersion/template-order/list';
  static const String serviceOrdersList = '$apiVersion/service-order/list';
  static const String adCampaignList = '$apiVersion/ad-campaign/list';
  static String cancelAdCampaign(dynamic id) => '$apiVersion/ad-campaign/$id/cancel';

  // Ad Placements Endpoints
  static const String adPlacementList = '$apiVersion/ad-placements/list';
  static const String searchAdPlacements = '$apiVersion/ad-placements/search';
  static const String uploadAdProof = '$apiVersion/ad-proofs';
  static String getAdProofs(dynamic placementId) => '$apiVersion/ad-proofs/placement/$placementId';
  static String acceptAdPlacement(dynamic id) => '$apiVersion/ad-placements/$id/accept';
  static String rejectAdPlacement(dynamic id) => '$apiVersion/ad-placements/$id/reject';
  static String inProgressAdPlacement(dynamic id) => '$apiVersion/ad-placements/$id/inprogress';
  static String completeAdPlacement(dynamic id) => '$apiVersion/ad-placements/$id/complete';
  static String cancelAdPlacement(dynamic id) => '$apiVersion/ad-placements/$id/cancel';
  static String serviceOrderItemDecision(dynamic itemId) => '$apiVersion/service-order/items/$itemId/decision';
  static String serviceOrderItemProgress(dynamic itemId) => '$apiVersion/service-order/items/$itemId/progress';
  static String serviceOrderItemDelivery(dynamic itemId) => '$apiVersion/service-order/items/$itemId/delivery';
  static String serviceOrderItemRevision(dynamic itemId) => '$apiVersion/service-order/items/$itemId/revision';

  // Support Endpoints
  static const String submitSupportTicket = '$apiVersion/support/ticket';
  static const String getSupportTickets = '$apiVersion/support/tickets';

  // Creator & User Endpoints
  static const String userAnalytics = '$apiVersion/user/me/analytics';
  static const String usersList = '$apiVersion/user/list';
  static const String searchUsers = '$apiVersion/user/search';
  static String userDetails(dynamic id) => '$apiVersion/user/details/$id';
  static String updateUser(dynamic id) => '$apiVersion/user/$id';

  // Location Endpoints
  static const String locationsList = '$apiVersion/location/list';
  static const String createLocation = '$apiVersion/location';
  static String updateLocation(dynamic id) => '$apiVersion/location/$id';
  static String deleteLocation(dynamic id) => '$apiVersion/location/$id';
  static String locationDetailsEndpoint(dynamic id) => '$apiVersion/location/$id';
  static String locationBlockedDates(dynamic id) => '$apiVersion/location/$id/blocked-dates';
  static String locationAvailability(dynamic id) => '$apiVersion/location/$id/availability';
  static const String locationDetails = '$apiVersion/location/details'; // + /:id
  static const String uploadFile = '$apiVersion/file/upload'; // File upload endpoint

  // Category Endpoints
  static const String categoryList = '$apiVersion/category/list';

  // Ad Slots Endpoints
  static const String adSlotsList = '$apiVersion/adslots/list';
  static const String searchAdSlots = '$apiVersion/adslots/search';
  static const String createAdSlot = '$apiVersion/adslots';
  static String updateAdSlot(dynamic id) => '$apiVersion/adslots/$id';
  static String deleteAdSlot(dynamic id) => '$apiVersion/adslots/$id';
  static const String adSlotsDetails = '$apiVersion/adslots/details'; // + /:id

  // KYC Endpoints
  static const String kycInitiate = '$apiVersion/kyc/initiate';
  static const String kycStatus = '$apiVersion/kyc/status';
  static const String kycSubmit = '$apiVersion/kyc/submit';
  static const String kycVerifyOtp = '$apiVersion/kyc/verify-otp';
  static const String kycFace = '$apiVersion/kyc/face';

  // Contact/Message Endpoints
  static const String sendMessage = '$apiVersion/message';

  // FAQ Endpoints
  static const String faqList = '$apiVersion/faq/list';

  // Digital Services Endpoints
  static const String createService = '$apiVersion/service';
  static const String servicesList = '$apiVersion/service/list';
  static const String serviceDetails = '$apiVersion/service/details'; // + /:id
  static const String searchServices = '$apiVersion/service/search';

  // Wallet Endpoints
  static const String walletMe = '$apiVersion/wallet/me';
  static const String walletTransactions =
      '$apiVersion/wallet/transactions/list';

  // Vetting Endpoints
  static const String vettingList = '$apiVersion/vetting/list';
  static const String vettingDetails = '$apiVersion/vetting/details'; // + /:id

  // Template Endpoints
  static const String templateList = '$apiVersion/template/list';
  static const String createTemplate = '$apiVersion/template';
  static const String templateDetails =
      '$apiVersion/template/details'; // + /:id
  static const String templateOrder = '$apiVersion/template-order';
  static String templateOrderDetails(dynamic id) =>
      '$apiVersion/template-order/details/$id';
  static const String myTemplates = '$apiVersion/template-order/mine';

  // Creative Endpoints
  static const String createCreative = '$apiVersion/creative';
  static const String creativesList = '$apiVersion/creative/list';
  static const String creativeDetails =
      '$apiVersion/creative/details'; // + /:id
  static const String creativeOrder = '$apiVersion/creative-order';
  static String creativeOrderDetails(dynamic id) =>
      '$apiVersion/creative-order/details/$id';
  static const String myCreatives = '$apiVersion/creative-order/mine';

  // Service Order Endpoint
  static const String serviceOrder = '$apiVersion/service-order';
  static const String myServices = '$apiVersion/service-order/mine';
  static String updateServiceRequirements(int itemId) =>
      '$apiVersion/service-order/items/$itemId/requirements';
  static String cancelServiceOrder(int itemId) =>
      '$apiVersion/service-order/items/$itemId/cancel';
  static String serviceOrderDetails(dynamic id) =>
      '$apiVersion/service-order/details/$id';

  // Wallet and Withdrawal Accounts Endpoints
  static const String walletDetails = '$apiVersion/wallet/details';
  static const String withdrawalAccount = '$apiVersion/wallet/withdrawal-account';
  static String updateWithdrawalAccount(int id) => '$withdrawalAccount/$id';
  static String deleteWithdrawalAccount(int id) => '$withdrawalAccount/$id';
  static String defaultWithdrawalAccount(int id) => '$withdrawalAccount/$id/default';
  static String reviewWithdrawalAccount(int id) => '$withdrawalAccount/$id/review';
  static String withdrawalAccountDetails(int id) => '$withdrawalAccount/details/$id';
  static const String withdrawalAccountList = '$withdrawalAccount/list';
  static const String withdrawalAccountSearch = '$withdrawalAccount/search';
  static const String withdrawalRequest = '$apiVersion/wallet/withdrawal-request';

  // Campaign Order Endpoint
  static const String campaignOrder = '$apiVersion/ad-campaign';

  // My Campaigns Endpoint
  static const String myCampaigns = '$apiVersion/ad-campaign/mine';

  // Campaign Details Endpoint
  static const String campaignDetails =
      '$apiVersion/ad-campaign/details'; // + /:id

  // Cancel Campaign Endpoint
  static String cancelCampaign(int campaignId) =>
      '$apiVersion/ad-campaign/$campaignId/cancel';

  // Payment Endpoints
  static const String paymentInitialize = '$apiVersion/payment/initialize';
  static const String paymentVerify =
      '$apiVersion/payment/verify'; // + /:reference
  static const String paymentStatus =
      '$apiVersion/payment/status'; // + /:reference

  // Social Account Endpoints
  static const String socialAccount = '$apiVersion/social-account';
  static const String mySocialAccounts = '$apiVersion/social-account/mine';

  // Notification Endpoints
  static const String notificationList = '$apiVersion/notification/list';
  static String markNotificationStatus(dynamic id, {String status = 'SEEN'}) =>
      '$apiVersion/notification/$id?status=$status';
  static const String notificationReadAll = '$apiVersion/notification/read-all';
}

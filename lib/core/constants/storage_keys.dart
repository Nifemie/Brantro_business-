/// Storage keys used throughout the app for SharedPreferences and SecureStorage
/// Centralizing these keys helps prevent typos and makes it easier to manage storage
class StorageKeys {
  // Private constructor to prevent instantiation
  StorageKeys._();

  // ==================== Session Keys ====================
  /// Key for storing user details JSON
  static const String userDetails = 'user_details';
  
  /// Key for storing username (email)
  static const String username = 'username';
  
  /// Key for storing user's full name
  static const String userFullname = 'user_fullname';
  
  /// Key for storing user's actual username (not email)
  static const String userActualUsername = 'user_actual_username';
  
  /// Key for storing user's phone number
  static const String userPhoneNumber = 'user_phone_number';
  
  /// Key for storing user's access token
  static const String accessToken = 'user_access_token';
  
  /// Key for storing user's role
  static const String userRole = 'user_role';
  
  /// Key for storing user's account type
  static const String accountType = 'account_type';

  // ==================== Cart Keys ====================
  /// Key for storing cart items
  static const String cart = 'cart_items';
  
  /// Key for storing campaign setup cache
  static const String campaignSetupCache = 'campaign_setup_cache';

  // ==================== App Settings Keys ====================
  /// Key for storing theme preference (light/dark)
  static const String themeMode = 'theme_mode';
  
  /// Key for storing language preference
  static const String language = 'language';
  
  /// Key for storing notification settings
  static const String notificationsEnabled = 'notifications_enabled';
  
  /// Key for storing biometric authentication preference
  static const String biometricEnabled = 'biometric_enabled';
  
  /// Key for storing passcode authentication preference
  static const String passcodeEnabled = 'passcode_enabled';
  
  /// Key for storing first launch flag
  static const String isFirstLaunch = 'is_first_launch';
  
  /// Key for storing onboarding completion flag
  static const String onboardingCompleted = 'onboarding_completed';

  // ==================== Cache Keys ====================
  /// Key for storing last sync timestamp
  static const String lastSyncTime = 'last_sync_time';
  
  /// Key for storing cached user profile
  static const String cachedProfile = 'cached_profile';
  
  /// Key for storing cached campaigns
  static const String cachedCampaigns = 'cached_campaigns';

  // ==================== Feature Flags ====================
  /// Key for storing feature flags
  static const String featureFlags = 'feature_flags';
  
  /// Key for storing A/B test variants
  static const String abTestVariants = 'ab_test_variants';

  // ==================== Analytics Keys ====================
  /// Key for storing analytics user ID
  static const String analyticsUserId = 'analytics_user_id';
  
  /// Key for storing analytics session ID
  static const String analyticsSessionId = 'analytics_session_id';

  // ==================== Search & History Keys ====================
  /// Key for storing search history
  static const String searchHistory = 'search_history';
  
  /// Key for storing recently viewed items
  static const String recentlyViewed = 'recently_viewed';
}

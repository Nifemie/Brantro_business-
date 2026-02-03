import 'package:go_router/go_router.dart';
import 'package:brantro/features/auth/presentation/splashscreen/splashscreen.dart';
import 'package:brantro/features/auth/presentation/introductory/intro_wrapper.dart';
import 'package:brantro/features/auth/presentation/onboarding/signin/signin.dart';
import 'package:brantro/features/auth/presentation/onboarding/signup/signup.dart';
import 'package:brantro/features/auth/presentation/onboarding/signup/role_details.dart';
import 'package:brantro/features/auth/presentation/onboarding/signup/account_details.dart';
import 'package:brantro/features/auth/presentation/onboarding/signup/verify_identity.dart';
import 'package:brantro/features/auth/presentation/onboarding/forget_password/forget_password_screen.dart';
import 'package:brantro/features/auth/presentation/onboarding/forget_password/forget_password_verification.dart';
import 'package:brantro/features/auth/presentation/onboarding/forget_password/reset_password.dart';
import 'package:brantro/features/home/presentation/screens/homeScreen.dart';
import 'package:brantro/features/notification/presentation/notification.dart';
import 'package:brantro/features/search/presentation/search_screen.dart';
import 'package:brantro/features/search/presentation/search_results_screen.dart';
import 'package:brantro/features/Explore/presentation/explore_screen.dart';
import 'package:brantro/features/main_shell.dart';
import 'package:brantro/features/product/presentation/product_details_screen.dart';
import 'package:brantro/features/account/presentation/user_account.dart';
import 'package:brantro/features/account/presentation/help_support_screen.dart';
import 'package:brantro/features/account/presentation/contact_us_screen.dart';
import 'package:brantro/features/campaign/presentation/campaigns_screen.dart';
import 'package:brantro/features/ad_slot/presentation/screens/create_ad_slot_screen.dart';
import 'package:brantro/features/ad_slot/presentation/screens/seller_ad_slots_screen.dart';
import 'package:brantro/features/ad_slot/presentation/screens/ad_slot_details_screen.dart';
import 'package:brantro/features/ad_slot/data/models/ad_slot_model.dart';
import 'package:brantro/features/vetting/presentation/screens/vetting_details_screen.dart';
import 'package:brantro/features/vetting/data/models/vetting_model.dart';
import 'package:brantro/features/KYC/presentation/kyc_landing_screen.dart';
import 'package:brantro/features/KYC/presentation/kyc_form_screen.dart';
import 'package:brantro/features/KYC/presentation/kyc_submission_screen.dart';
import 'package:brantro/features/KYC/presentation/kyc_status_screen.dart';
import 'package:brantro/features/KYC/presentation/kyc_verification_screen.dart';
import 'package:brantro/features/KYC/presentation/face_verification_screen.dart';
import 'package:brantro/features/KYC/presentation/kyc_gate_screen.dart';
import 'package:brantro/features/billboard/data/models/billboard_model.dart';
import 'package:brantro/features/billboard/presentation/screens/asset_details_screen.dart';
import 'package:brantro/features/KYC/data/kyc_models.dart';
import 'package:brantro/features/Digital_services/presentation/screens/services_listing_screen.dart';
import 'package:brantro/features/Digital_services/presentation/screens/service_details_screen.dart';
import 'package:brantro/features/wallet/presentation/wallet_screen.dart';
import 'package:brantro/features/wallet/presentation/transaction_history_screen.dart';
import 'package:brantro/features/vetting/presentation/screens/vetting_listing_screen.dart';
import 'package:brantro/features/campaign/presentation/campaigns_listing_screen.dart';
import 'package:brantro/features/profile/presentation/view_profile_screen.dart';
import 'package:brantro/features/account/presentation/settings_screen.dart';
import 'package:brantro/features/account/presentation/profile_details_screen.dart';
import 'package:brantro/features/account/presentation/edit_profile_screen.dart';
import 'package:brantro/features/template/presentation/screens/template_listing_screen.dart';
import 'package:brantro/features/template/presentation/screens/template_details_screen.dart';
import 'package:brantro/features/template/presentation/screens/my_templates_screen.dart';
import 'package:brantro/features/template/data/models/template_model.dart';
import 'package:brantro/features/creatives/presentation/screens/creatives_listing_screen.dart';
import 'package:brantro/features/creatives/presentation/screens/creative_detail_screen.dart';
import 'package:brantro/features/creatives/presentation/screens/my_creatives_screen.dart';
import 'package:brantro/features/cart/presentation/screens/checkout_screen.dart';
import 'package:brantro/features/cart/presentation/screens/service_setup_screen.dart';
import 'package:brantro/features/cart/presentation/screens/campaign_setup_screen.dart';
import 'package:brantro/features/campaign/presentation/screens/campaign_details_screen.dart';
import 'package:brantro/features/Digital_services/data/models/service_model.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
      routes: [
        GoRoute(
          path: 'intro',
          name: 'intro',
          builder: (context, state) => const IntroWrapper(),
        ),
        GoRoute(
          path: 'signin',
          name: 'signin',
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: 'signup',
          name: 'signup',
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: 'role-details',
          name: 'role-details',
          builder: (context, state) {
            final extra = (state.extra ?? {}) as Map;
            return RoleDetailsScreen(
              role: extra['role']?.toString() ?? '',
              accountType: extra['accountType']?.toString() ?? '',
            );
          },
        ),
        GoRoute(
          path: 'account-details',
          name: 'account-details',
          builder: (context, state) {
            final extra = (state.extra ?? {}) as Map;
            return AccountDetailsScreen(
              role: extra['role']?.toString() ?? '',
              accountType: extra['accountType']?.toString() ?? '',
              roleData: (extra['roleData'] as Map?) != null
                  ? Map<String, dynamic>.from(extra['roleData'])
                  : {},
            );
          },
        ),
        GoRoute(
          path: 'verify-identity',
          name: 'verify-identity',
          builder: (context, state) {
            final extra = (state.extra ?? {}) as Map;
            final email = extra['email']?.toString() ?? '';
            final phoneNumber = extra['phoneNumber']?.toString() ?? '';
            return VerifyIdentityScreen(email: email, phoneNumber: phoneNumber);
          },
        ),
        GoRoute(
          path: 'forgot-password',
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: 'forgot-password-verification',
          name: 'forgot-password-verification',
          builder: (context, state) {
            final extra = (state.extra ?? {}) as Map;
            final identity = extra['identity']?.toString() ?? '';
            return ForgotPasswordVerificationScreen(identity: identity);
          },
        ),
        GoRoute(
          path: 'reset-password',
          name: 'reset-password',
          builder: (context, state) {
            final extra = (state.extra ?? {}) as Map;
            final identity = extra['identity']?.toString() ?? '';
            return ResetPasswordScreen(identity: identity);
          },
        ),

        // Shell Route for Bottom Navigation
        ShellRoute(
          builder: (context, state, child) {
            return MainShell(child: child);
          },
          routes: [
            GoRoute(
              path: 'home',
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: 'explore',
              name: 'explore',
              builder: (context, state) {
                final category = state.uri.queryParameters['category'];
                return ExploreScreen(category: category);
              },
            ),
            GoRoute(
              path: 'campaigns',
              name: 'campaigns',
              builder: (context, state) => const CampaignsScreen(),
            ),
            GoRoute(
              path: 'account',
              name: 'account',
              builder: (context, state) => const UserAccount(),
            ),
            GoRoute(
              path: 'wallet',
              name: 'wallet',
              builder: (context, state) => const WalletScreen(),
            ),
          ],
        ),

        // Routes NOT part of the bottom shell (full screen)
        GoRoute(
          path: 'notification',
          name: 'notification',
          builder: (context, state) => const NotificationScreen(),
        ),
        GoRoute(
          path: 'search',
          name: 'search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: 'search-results',
          name: 'search-results',
          builder: (context, state) {
            final query = state.uri.queryParameters['query'] ?? '';
            return SearchResultsScreen(searchQuery: query);
          },
        ),
        GoRoute(
          path: 'product-details',
          name: 'product-details',
          builder: (context, state) {
            final product = state.extra as Map<String, dynamic>;
            return ProductDetailsScreen(product: product);
          },
        ),
        GoRoute(
          path: 'create-ad-slot',
          name: 'create-ad-slot',
          builder: (context, state) => const CreateAdSlotScreen(),
        ),
        GoRoute(
          path: 'ad-slot-details/:slotId',
          name: 'ad-slot-details',
          builder: (context, state) {
            final slotId = state.pathParameters['slotId']!;
            
            // Handle both AdSlot and Map cases
            bool hideBooking = false;
            AdSlot? adSlot;
            
            if (state.extra is Map<String, dynamic>) {
              final extra = state.extra as Map<String, dynamic>;
              adSlot = extra['initialData'] as AdSlot?;
              hideBooking = extra['hideBooking'] as bool? ?? false;
            } else if (state.extra is AdSlot) {
              adSlot = state.extra as AdSlot;
            }
            
            return AdSlotDetailsScreen(
              adSlotId: slotId,
              initialData: adSlot,
              hideBooking: hideBooking,
            );
          },
        ),
        GoRoute(
          path: 'artist-ad-slots/:userId',
          name: 'artist-ad-slots',
          builder: (context, state) {
            final userId = int.parse(state.pathParameters['userId'] ?? '0');
            final extra = (state.extra ?? {}) as Map;
            return SellerAdSlotsScreen(
              userId: userId,
              sellerName: extra['sellerName']?.toString(),
              sellerAvatar: extra['sellerAvatar']?.toString(),
              sellerType: extra['sellerType']?.toString() ?? 'Artist',
            );
          },
        ),
        GoRoute(
          path: 'seller-ad-slots/:userId',
          name: 'seller-ad-slots',
          builder: (context, state) {
            final userId = int.parse(state.pathParameters['userId'] ?? '0');
            final extra = (state.extra ?? {}) as Map;
            return SellerAdSlotsScreen(
              userId: userId,
              sellerName: extra['sellerName']?.toString(),
              sellerAvatar: extra['sellerAvatar']?.toString(),
              sellerType: extra['sellerType']?.toString() ?? 'Seller',
            );
          },
        ),
        GoRoute(
          path: 'asset-details',
          name: 'asset-details',
          builder: (context, state) {
            final asset = state.extra as dynamic;
            return AssetDetailsScreen(asset: asset);
          },
        ),

        // KYC Routes
        GoRoute(
          path: 'kyc-gate',
          name: 'kyc-gate',
          builder: (context, state) {
            final extra = (state.extra ?? {}) as Map;
            return KycGateScreen(
              requiredFor: extra['requiredFor']?.toString() ?? 'this action',
              returnRoute: extra['returnRoute']?.toString(),
            );
          },
        ),
        GoRoute(
          path: 'kyc',
          name: 'kyc',
          builder: (context, state) => const KycLandingScreen(),
        ),
        GoRoute(
          path: 'kyc/form',
          name: 'kyc-form',
          builder: (context, state) => const KycFormScreen(),
        ),
        GoRoute(
          path: 'kyc/submit',
          name: 'kyc-submit',
          builder: (context, state) {
            final request = state.extra as KycVerificationRequest;
            return KycSubmissionScreen(request: request);
          },
        ),
        GoRoute(
          path: 'kyc/verify',
          name: 'kyc-verify',
          builder: (context, state) {
            final documentNumber = state.extra as String;
            return KycVerificationScreen(documentNumber: documentNumber);
          },
        ),
        GoRoute(
          path: 'kyc/face-verify',
          name: 'kyc-face-verify',
          builder: (context, state) {
            final documentNumber = state.extra as String;
            return FaceVerificationScreen(documentNumber: documentNumber);
          },
        ),
        GoRoute(
          path: 'kyc/status',
          name: 'kyc-status',
          builder: (context, state) => const KycStatusScreen(),
        ),
        GoRoute(
          path: 'help-support',
          name: 'help-support',
          builder: (context, state) => const HelpSupportScreen(),
        ),
        GoRoute(
          path: 'contact-us',
          name: 'contact-us',
          builder: (context, state) => const ContactUsScreen(),
        ),
        GoRoute(
          path: 'settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: 'profile-details',
          name: 'profile-details',
          builder: (context, state) => const ProfileDetailsScreen(),
        ),
        GoRoute(
          path: 'edit-profile',
          name: 'edit-profile',
          builder: (context, state) {
            final userData = state.extra as Map<String, dynamic>?;
            return EditProfileScreen(userData: userData);
          },
        ),
        GoRoute(
          path: 'services',
          name: 'services',
          builder: (context, state) {
            final serviceType = state.uri.queryParameters['type'];
            return ServicesListingScreen(serviceType: serviceType);
          },
        ),
        GoRoute(
          path: 'service-details/:serviceId',
          name: 'service-details',
          builder: (context, state) {
            final serviceId = state.pathParameters['serviceId']!;
            final initialData = state.extra as dynamic; // Can be ServiceModel or null
            // Check if extra is ServiceModel, otherwise null
            // (Dart type check would be needed if strictly importing model here)
            return ServiceDetailsScreen(
                serviceId: serviceId, 
                initialData: initialData is ServiceModel ? initialData : null
            ); // ServiceModel import needed in app_routes if strictly typed
          },
        ),
        GoRoute(
          path: 'vetting',
          name: 'vetting',
          builder: (context, state) => const VettingListingScreen(),
        ),
        GoRoute(
          path: 'template',
          name: 'template',
          builder: (context, state) => const TemplateListingScreen(),
        ),
        GoRoute(
          path: 'my-templates',
          name: 'my-templates',
          builder: (context, state) => const MyTemplatesScreen(),
        ),
        GoRoute(
          path: 'template-details/:templateId',
          name: 'template-details',
          builder: (context, state) {
            final templateId = state.pathParameters['templateId']!;
            
            // Handle both Map and direct TemplateModel cases
            TemplateModel? initialData;
            bool isPurchased = false;
            
            if (state.extra is Map<String, dynamic>) {
              final extra = state.extra as Map<String, dynamic>;
              initialData = extra['initialData'] as TemplateModel?;
              isPurchased = extra['isPurchased'] as bool? ?? false;
            } else if (state.extra is TemplateModel) {
              initialData = state.extra as TemplateModel;
              isPurchased = false;
            }
            
            return TemplateDetailsScreen(
              templateId: templateId,
              initialData: initialData,
              isPurchased: isPurchased,
            );
          },
        ),
        GoRoute(
          path: 'creatives',
          name: 'creatives',
          builder: (context, state) => const CreativesListingScreen(),
        ),
        GoRoute(
          path: 'my-creatives',
          name: 'my-creatives',
          builder: (context, state) => const MyCreativesScreen(),
        ),
        GoRoute(
          path: 'creative-details/:creativeId',
          name: 'creative-details',
          builder: (context, state) {
            final creativeId = int.parse(state.pathParameters['creativeId'] ?? '0');
            
            // Handle both Map and direct data cases
            bool isPurchased = false;
            
            if (state.extra is Map<String, dynamic>) {
              final extra = state.extra as Map<String, dynamic>;
              isPurchased = extra['isPurchased'] as bool? ?? false;
            }
            
            return CreativeDetailScreen(
              creativeId: creativeId,
              isPurchased: isPurchased,
            );
          },
        ),
        GoRoute(
          path: 'campaigns-list',
          name: 'campaigns-list',
          builder: (context, state) {
            final category = state.uri.queryParameters['category'];
            return CampaignsListingScreen(category: category);
          },
        ),
        GoRoute(
          path: 'view-profile',
          name: 'view-profile',
          builder: (context, state) {
            final profileData = state.extra as Map<String, dynamic>;
            return ViewProfileScreen(profileData: profileData);
          },
        ),
        GoRoute(
          path: 'wallet/transactions',
          name: 'wallet-transactions',
          builder: (context, state) => const TransactionHistoryScreen(),
        ),
        GoRoute(
          path: 'checkout',
          name: 'checkout',
          builder: (context, state) => const CheckoutScreen(),
        ),
        GoRoute(
          path: 'service-setup',
          name: 'service-setup',
          builder: (context, state) => const ServiceSetupScreen(),
        ),
        GoRoute(
          path: 'campaign-setup',
          name: 'campaign-setup',
          builder: (context, state) => const CampaignSetupScreen(),
        ),
        GoRoute(
          path: 'campaign-details/:campaignId',
          name: 'campaign-details',
          builder: (context, state) {
            final campaignId = int.parse(state.pathParameters['campaignId']!);
            return CampaignDetailsScreen(campaignId: campaignId);
          },
        ),
        GoRoute(
          path: 'vetting-details/:vettingId',
          name: 'vetting-details',
          builder: (context, state) {
            final vettingId = state.pathParameters['vettingId']!;
            final vetting = state.extra as dynamic; // Cast to dynamic first to avoid type errors
            return VettingDetailsScreen(
              vettingId: vettingId,
              // Map dynamic/object to VettingOptionModel if possible, or leave null for fresh fetch
              initialData: vetting is VettingOptionModel ? vetting : null,
            );
          },
        ),
      ],
    ),
  ],
);

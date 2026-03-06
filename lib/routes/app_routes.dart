import 'package:go_router/go_router.dart';
import 'package:brantro_business/features/auth/presentation/splashscreen/splashscreen.dart';
import 'package:brantro_business/features/auth/presentation/introductory/intro_wrapper.dart';
import 'package:brantro_business/features/auth/presentation/onboarding/signin/signin.dart';
import 'package:brantro_business/features/auth/presentation/onboarding/signup/signup.dart';
import 'package:brantro_business/features/auth/presentation/onboarding/signup/role_details.dart';
import 'package:brantro_business/features/auth/presentation/onboarding/signup/account_details.dart';
import 'package:brantro_business/features/auth/presentation/onboarding/signup/verify_identity.dart';
import 'package:brantro_business/features/auth/presentation/onboarding/forget_password/forget_password_screen.dart';
import 'package:brantro_business/features/auth/presentation/onboarding/forget_password/forget_password_verification.dart';
import 'package:brantro_business/features/auth/presentation/onboarding/forget_password/reset_password.dart';
import 'package:brantro_business/features/dashboard/presentation/screens/dashboard_shell.dart';
import 'package:brantro_business/features/account/presentation/user_account.dart';
import 'package:brantro_business/features/template/presentation/screen/template_marketplace/template_marketplace.dart';
import 'package:brantro_business/features/template/presentation/screen/upload_template/upload_template_screen.dart';
import 'package:brantro_business/features/creative/presentation/screen/creative_marketplace/creative_marketplace.dart';
import 'package:brantro_business/features/creative/presentation/screen/upload_creative/upload_creative_screen.dart';
import 'package:brantro_business/features/notification/presentation/screens/notification_screen.dart';
import 'package:brantro_business/features/services/presentation/screen/service_marketplace/service_marketplace.dart';
import 'package:brantro_business/features/manage_billboard/presentation/screen/manage_billboard/manage_billboard.dart';
import 'package:brantro_business/features/manage_billboard/presentation/screen/ads_slots/ads_slots_screen.dart';
import 'package:brantro_business/features/billboard/presentation/screens/billboard_marketplace_screen.dart';
import 'package:brantro_business/features/billboard/presentation/screens/upload_billboard_screen.dart';
import 'package:brantro_business/features/billboard/presentation/screens/billboard_details_screen.dart';
import 'package:brantro_business/features/billboard/presentation/screens/billboard_orders_screen.dart';
import 'package:brantro_business/features/billboard/data/models/billboard_model.dart';
import 'package:brantro_business/features/wall/presentation/screens/wall_marketplace_screen.dart';
import 'package:brantro_business/features/wall/presentation/screens/upload_wall_screen.dart';
import 'package:brantro_business/features/wall/presentation/screens/wall_details_screen.dart';
import 'package:brantro_business/features/wall/data/models/wall_model.dart';
import 'package:brantro_business/features/screen/presentation/screens/screen_marketplace_screen.dart';
import 'package:brantro_business/features/screen/presentation/screens/upload_screen_screen.dart';
import 'package:brantro_business/features/screen/presentation/screens/screen_details_screen.dart';
import 'package:brantro_business/features/screen/data/models/screen_model.dart';
import 'package:brantro_business/features/ad_slot/presentation/screens/ad_slot_screen.dart';
import 'package:brantro_business/features/ad_slot/presentation/screens/create_ad_slot_screen.dart';
import 'package:brantro_business/core/screens/ad_campaign_screen.dart';
import 'package:brantro_business/features/orders/presentation/screens/orders_screen.dart';
import 'package:brantro_business/features/orders/presentation/screens/order_details_screen.dart';
import 'package:brantro_business/features/orders/data/models/order_model.dart';
import 'package:brantro_business/core/service/session_service.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final isLoggedIn = await SessionService.isLoggedIn();
    final isOnSplash = state.matchedLocation == '/';
    final isOnAuth =
        state.matchedLocation.startsWith('/signin') ||
        state.matchedLocation.startsWith('/signup') ||
        state.matchedLocation.startsWith('/intro') ||
        state.matchedLocation.startsWith('/forgot-password');

    // If user is logged in and trying to access splash or auth screens, redirect to dashboard
    if (isLoggedIn && (isOnSplash || isOnAuth)) {
      return '/dashboard';
    }

    // Allow navigation to continue
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/intro',
      name: 'intro',
      builder: (context, state) => const IntroWrapper(),
    ),
    GoRoute(
      path: '/signin',
      name: 'signin',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/role-details',
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
      path: '/account-details',
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
      path: '/verify-identity',
      name: 'verify-identity',
      builder: (context, state) {
        final extra = (state.extra ?? {}) as Map;
        final email = extra['email']?.toString() ?? '';
        final phoneNumber = extra['phoneNumber']?.toString() ?? '';
        return VerifyIdentityScreen(email: email, phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/forgot-password-verification',
      name: 'forgot-password-verification',
      builder: (context, state) {
        final extra = (state.extra ?? {}) as Map;
        final identity = extra['identity']?.toString() ?? '';
        return ForgotPasswordVerificationScreen(identity: identity);
      },
    ),
    GoRoute(
      path: '/reset-password',
      name: 'reset-password',
      builder: (context, state) {
        final extra = (state.extra ?? {}) as Map;
        final identity = extra['identity']?.toString() ?? '';
        return ResetPasswordScreen(identity: identity);
      },
    ),

    // Dashboard Route
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardShell(),
    ),

    // Orders Route
    GoRoute(
      path: '/orders',
      name: 'orders',
      builder: (context, state) => const OrdersScreen(),
    ),

    // Order Details Route
    GoRoute(
      path: '/order-details',
      name: 'order-details',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final order = extra['order'] as OrderModel;
        return OrderDetailsScreen(order: order);
      },
    ),

    // Profile/Account Route
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const UserAccount(),
    ),

    // Template Marketplace Route
    GoRoute(
      path: '/template-marketplace',
      name: 'template-marketplace',
      builder: (context, state) => const TemplateMarketplaceScreen(),
    ),

    // Upload Template Route
    GoRoute(
      path: '/upload-template',
      name: 'upload-template',
      builder: (context, state) => const UploadTemplateScreen(),
    ),

    // Creative Marketplace Route
    GoRoute(
      path: '/creative-marketplace',
      name: 'creative-marketplace',
      builder: (context, state) => const CreativeMarketplaceScreen(),
    ),

    // Upload Creative Route
    GoRoute(
      path: '/upload-creative',
      name: 'upload-creative',
      builder: (context, state) => const UploadCreativeScreen(),
    ),

    // Notifications Route
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      builder: (context, state) => const NotificationScreen(),
    ),

    // Service Marketplace Route
    GoRoute(
      path: '/service-marketplace',
      name: 'service-marketplace',
      builder: (context, state) => const ServiceMarketplaceScreen(),
    ),

    // Billboard Marketplace Route
    GoRoute(
      path: '/billboard-marketplace',
      name: 'billboard-marketplace',
      builder: (context, state) => const BillboardMarketplaceScreen(),
    ),

    // Upload Billboard Route
    GoRoute(
      path: '/upload-billboard',
      name: 'upload-billboard',
      builder: (context, state) => const UploadBillboardScreen(),
    ),

    // Billboard Details Route
    GoRoute(
      path: '/billboard-details',
      name: 'billboard-details',
      builder: (context, state) {
        final extra = (state.extra ?? {}) as Map;
        final billboard = extra['billboard'] as BillboardModel;
        return BillboardDetailsScreen(billboard: billboard);
      },
    ),

    // Billboard Orders Route
    GoRoute(
      path: '/billboard-orders',
      name: 'billboard-orders',
      builder: (context, state) {
        final extra = (state.extra ?? {}) as Map;
        final billboardId = extra['billboardId']?.toString() ?? '';
        return BillboardOrdersScreen(billboardId: billboardId);
      },
    ),

    // Wall Marketplace Route
    GoRoute(
      path: '/wall-marketplace',
      name: 'wall-marketplace',
      builder: (context, state) => const WallMarketplaceScreen(),
    ),

    // Upload Wall Route
    GoRoute(
      path: '/upload-wall',
      name: 'upload-wall',
      builder: (context, state) => const UploadWallScreen(),
    ),

    // Wall Details Route
    GoRoute(
      path: '/wall-details',
      name: 'wall-details',
      builder: (context, state) {
        final extra = (state.extra ?? {}) as Map;
        final wall = extra['wall'] as WallModel;
        return WallDetailsScreen(wall: wall);
      },
    ),

    // Screen Marketplace Route
    GoRoute(
      path: '/screen-marketplace',
      name: 'screen-marketplace',
      builder: (context, state) => const ScreenMarketplaceScreen(),
    ),

    // Upload Screen Route
    GoRoute(
      path: '/upload-screen',
      name: 'upload-screen',
      builder: (context, state) => const UploadScreenScreen(),
    ),

    // Screen Details Route
    GoRoute(
      path: '/screen-details',
      name: 'screen-details',
      builder: (context, state) {
        final extra = (state.extra ?? {}) as Map;
        final screen = extra['screen'] as ScreenModel;
        return ScreenDetailsScreen(screen: screen);
      },
    ),

    // Ad Slot Route (Reusable for Billboard/Wall/Screen)
    GoRoute(
      path: '/ad-slots',
      name: 'ad-slots',
      builder: (context, state) {
        final extra = (state.extra ?? {}) as Map;
        final parentId = extra['parentId']?.toString() ?? '';
        final parentType = extra['parentType']?.toString() ?? 'billboard';
        final parentName = extra['parentName']?.toString() ?? '';
        return AdSlotScreen(
          parentId: parentId,
          parentType: parentType,
          parentName: parentName,
        );
      },
    ),

    // Create Ad Slot Route
    GoRoute(
      path: '/create-ad-slot',
      name: 'create-ad-slot',
      builder: (context, state) {
        final extra = (state.extra ?? {}) as Map;
        final parentId = extra['parentId']?.toString() ?? '';
        final parentType = extra['parentType']?.toString() ?? 'billboard';
        final parentName = extra['parentName']?.toString() ?? '';
        return CreateAdSlotScreen(
          parentId: parentId,
          parentType: parentType,
          parentName: parentName,
        );
      },
    ),

    // Ad Campaign Route (Orders/Campaigns for Billboard/Wall/Screen)
    GoRoute(
      path: '/ad-campaigns',
      name: 'ad-campaigns',
      builder: (context, state) {
        final extra = (state.extra ?? {}) as Map;
        final parentId = extra['parentId']?.toString() ?? '';
        final parentType = extra['parentType']?.toString() ?? 'billboard';
        final parentName = extra['parentName']?.toString() ?? '';
        return AdCampaignScreen(
          parentId: parentId,
          parentType: parentType,
          parentName: parentName,
        );
      },
    ),

    // Manage Billboard Route
    GoRoute(
      path: '/manage-billboard',
      name: 'manage-billboard',
      builder: (context, state) => const ManageBillboardScreen(),
    ),

    // Ads Slots Route
    GoRoute(
      path: '/ads-slots',
      name: 'ads-slots',
      builder: (context, state) {
        final extra = (state.extra ?? {}) as Map;
        final billboardTitle =
            extra['billboardTitle']?.toString() ?? 'Billboard';
        return AdsSlotsScreen(billboardTitle: billboardTitle);
      },
    ),
  ],
);

import 'package:flutter/material.dart';
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
import 'package:brantro_business/features/wallet/presentation/wallet_screen.dart';
import 'package:brantro_business/features/wallet/presentation/transaction_history_screen.dart';
import 'package:brantro_business/features/wallet/presentation/transaction_receipt_screen.dart';
import 'package:brantro_business/features/wallet/presentation/withdrawal_accounts_screen.dart';
import 'package:brantro_business/features/wallet/presentation/withdraw_screen.dart';
import 'package:brantro_business/features/wallet/data/models/transaction_model.dart';
import 'package:brantro_business/features/account/presentation/settings_screen.dart';
import 'package:brantro_business/features/account/presentation/payment_settings_screen.dart';
import 'package:brantro_business/features/account/presentation/address_book_screen.dart';
import 'package:brantro_business/features/account/presentation/account_management_screen.dart';
import 'package:brantro_business/features/account/presentation/edit_profile_screen.dart';
import 'package:brantro_business/features/account/presentation/help_support_screen.dart';
import 'package:brantro_business/features/account/presentation/contact_us_screen.dart';
import 'package:brantro_business/features/account/presentation/terms_of_service_screen.dart';
import 'package:brantro_business/features/account/presentation/privacy_policy_screen.dart';
import 'package:brantro_business/features/template/presentation/screen/template_marketplace/template_marketplace.dart';
import 'package:brantro_business/features/template/presentation/screen/template_marketplace/template_details_screen.dart';
import 'package:brantro_business/features/template/data/models/template_model.dart';
import 'package:brantro_business/features/template/presentation/screen/upload_template/upload_template_screen.dart';
import 'package:brantro_business/features/creative/presentation/screen/creative_marketplace/creative_marketplace.dart';
import 'package:brantro_business/features/creative/presentation/screen/creative_marketplace/creative_details_screen.dart';
import 'package:brantro_business/features/creative/presentation/screen/upload_creative/upload_creative_screen.dart';
import 'package:brantro_business/features/creative/data/models/creative_model.dart';
import 'package:brantro_business/features/notification/presentation/screens/notification_screen.dart';
import 'package:brantro_business/features/services/presentation/screen/service_marketplace/service_marketplace.dart';
import 'package:brantro_business/features/services/presentation/screen/service_marketplace/service_details_screen.dart';
import 'package:brantro_business/features/services/presentation/screen/upload_service/upload_service_screen.dart';
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
import 'package:brantro_business/features/vehicle/presentation/screens/vehicle_marketplace_screen.dart';
import 'package:brantro_business/features/vehicle/presentation/screens/upload_vehicle_screen.dart';
import 'package:brantro_business/features/vehicle/presentation/screens/vehicle_details_screen.dart';
import 'package:brantro_business/features/vehicle/data/models/vehicle_model.dart';
import 'package:brantro_business/features/services/data/models/service_model.dart';
import 'package:brantro_business/features/ad_slot/presentation/screens/ad_slot_screen.dart';
import 'package:brantro_business/features/ad_slot/presentation/screens/create_ad_slot_screen.dart';
import 'package:brantro_business/features/ad_slot/presentation/screens/all_ad_slots_screen.dart';
import 'package:brantro_business/features/faq/presentation/screens/faq_screen.dart';
import 'package:brantro_business/features/announcement/presentation/screens/announcement_screen.dart';
import 'package:brantro_business/core/screens/ad_campaign_screen.dart';
import 'package:brantro_business/features/orders/presentation/screens/orders_screen.dart';
import 'package:brantro_business/features/orders/presentation/screens/order_details_screen.dart';
import 'package:brantro_business/features/orders/data/models/order_model.dart';
import 'package:brantro_business/core/service/session_service.dart';
import 'package:brantro_business/features/chat/presentation/screens/chat_screen.dart';
import 'package:brantro_business/features/KYC/presentation/kyc_landing_screen.dart';
import 'package:brantro_business/features/KYC/presentation/kyc_form_screen.dart';
import 'package:brantro_business/features/KYC/presentation/kyc_submission_screen.dart';
import 'package:brantro_business/features/KYC/presentation/kyc_verification_screen.dart';
import 'package:brantro_business/features/KYC/presentation/face_verification_screen.dart';
import 'package:brantro_business/features/KYC/presentation/kyc_status_screen.dart';
import 'package:brantro_business/features/KYC/presentation/kyc_gate_screen.dart';
import 'package:brantro_business/features/KYC/data/kyc_models.dart';
import 'package:brantro_business/features/auth/presentation/lock_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Back to Dashboard'),
            ),
          ],
        ),
      ),
    ),
  ),
  redirect: (context, state) async {
    final isLoggedIn = await SessionService.isLoggedIn();
    final loc = state.matchedLocation;
    final isOnSplash = loc == '/';
    final isOnAuth =
        loc.startsWith('/signin') ||
        loc.startsWith('/signup') ||
        loc.startsWith('/intro') ||
        loc.startsWith('/forgot-password') ||
        loc.startsWith('/forgot-password-verification') ||
        loc.startsWith('/verify-identity') ||
        loc.startsWith('/reset-password') ||
        loc.startsWith('/role-details') ||
        loc.startsWith('/account-details') ||
        loc.startsWith('/role-profile');
    final isOnLock = loc == '/lock';

    // 1. If not logged in, only allow splash & auth routes
    if (!isLoggedIn) {
      if (isOnSplash || isOnAuth) return null;
      return '/signin';
    }

    // Check if session is locked (BRT-024)
    final isLocked = await SessionService.isAppLocked();
    if (isLocked) {
      if (isOnLock) return null;
      return '/lock';
    } else if (isOnLock) {
      return '/dashboard';
    }

    // 2. KYC Verification Gate (Temporarily commented for testing):
    // final user = await SessionService.getUser();
    // final isVerified = (user is Map) &&
    //     (user['isVerified'] == true ||
    //         user['kycStatus']?.toString().toUpperCase() == 'APPROVED' ||
    //         user['kycStatus']?.toString().toUpperCase() == 'COMPLETED');
    // if (!isVerified) {
    //   if (isOnKyc) return null;
    //   return '/kyc';
    // }

    final isPasswordReset =
        loc.startsWith('/forgot-password') ||
        loc.startsWith('/forgot-password-verification') ||
        loc.startsWith('/reset-password');

    // 3. If logged in, allow password reset flow, otherwise redirect away from splash & auth to dashboard
    if (isPasswordReset) {
      return null;
    }
    if (isOnSplash || isOnAuth) {
      return '/dashboard';
    }

    // Allow navigation
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
      path: '/lock',
      name: 'lock',
      builder: (context, state) => const LockScreen(),
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
        final otp = extra['otp']?.toString();
        return ResetPasswordScreen(identity: identity, otp: otp);
      },
    ),

    // Dashboard Route
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardShell(),
    ),

    // Chat Route
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/wallet',
      name: 'wallet',
      builder: (context, state) => const WalletScreen(),
    ),
    GoRoute(
      path: '/wallet/transactions',
      name: 'wallet-transactions',
      builder: (context, state) => const TransactionHistoryScreen(),
    ),
    GoRoute(
      path: '/wallet/transaction-receipt',
      name: 'transaction-receipt',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Map<String, dynamic> && extra['transaction'] is TransactionModel) {
          return TransactionReceiptScreen(transaction: extra['transaction'] as TransactionModel);
        } else if (extra is TransactionModel) {
          return TransactionReceiptScreen(transaction: extra);
        }
        return const Scaffold(
          body: Center(child: Text('Transaction details not found')),
        );
      },
    ),

    GoRoute(
      path: '/wallet/withdrawal-accounts',
      name: 'withdrawal-accounts',
      builder: (context, state) => const WithdrawalAccountsScreen(),
    ),
    GoRoute(
      path: '/wallet/withdraw',
      name: 'withdraw',
      builder: (context, state) => const WithdrawScreen(),
    ),

    // Orders Route
    GoRoute(
      path: '/orders',
      name: 'orders',
      builder: (context, state) {
        final extra = state.extra;
        Map<String, String>? filters;
        if (extra is Map) {
          filters = extra.map((key, value) => MapEntry(key.toString(), value.toString()));
        }
        return OrdersScreen(filters: filters, showBackButton: true);
      },
    ),

    // Order Details Route
    GoRoute(
      path: '/order-details',
      name: 'order-details',
      builder: (context, state) {
        final extra = state.extra;
        OrderModel? order;
        if (extra is OrderModel) {
          order = extra;
        } else if (extra is Map && extra['order'] is OrderModel) {
          order = extra['order'] as OrderModel;
        }
        if (order != null) {
          return OrderDetailsScreen(order: order);
        }
        return const Scaffold(
          body: Center(child: Text('Order details not found')),
        );
      },
    ),

    // Order Details By ID Route (Notification / Deep Links)
    GoRoute(
      path: '/orders/details/:orderId',
      name: 'order-details-by-id',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId'];
        final extra = state.extra;
        OrderModel? order;
        if (extra is OrderModel) {
          order = extra;
        } else if (extra is Map && extra['order'] is OrderModel) {
          order = extra['order'] as OrderModel;
        }
        return OrderDetailsScreen(order: order, orderId: orderId);
      },
    ),

    // Profile/Account Route
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const UserAccount(showBackButton: true),
    ),

    // Edit Profile Route
    GoRoute(
      path: '/edit-profile',
      name: 'edit-profile',
      builder: (context, state) {
        final raw = state.extra;
        final userData = raw is Map ? Map<String, dynamic>.from(raw) : null;
        return EditProfileScreen(userData: userData);
      },
    ),

    // Settings Route
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/payment-settings',
      name: 'payment-settings',
      builder: (context, state) => const PaymentSettingsScreen(),
    ),
    GoRoute(
      path: '/address-book',
      name: 'address-book',
      builder: (context, state) => const AddressBookScreen(),
    ),
    GoRoute(
      path: '/account-management',
      name: 'account-management',
      builder: (context, state) => const AccountManagementScreen(),
    ),
    GoRoute(
      path: '/help-support',
      name: 'help-support',
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      path: '/contact-us',
      name: 'contact-us',
      builder: (context, state) => const ContactUsScreen(),
    ),
    GoRoute(
      path: '/faq',
      name: 'faq',
      builder: (context, state) => const FaqScreen(),
    ),
    GoRoute(
      path: '/terms-of-service',
      name: 'terms-of-service',
      builder: (context, state) => const TermsOfServiceScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      name: 'privacy-policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),

    // Template Marketplace Route
    GoRoute(
      path: '/template-marketplace',
      name: 'template-marketplace',
      builder: (context, state) => const TemplateMarketplaceScreen(),
    ),

    // Template Details Route
    GoRoute(
      path: '/template-details',
      name: 'template-details',
      builder: (context, state) {
        final extra = state.extra;
        TemplateModel? template;
        if (extra is TemplateModel) {
          template = extra;
        } else if (extra is Map && extra['template'] is TemplateModel) {
          template = extra['template'] as TemplateModel;
        }
        if (template != null) {
          return TemplateDetailsScreen(template: template);
        }
        return const Scaffold(
          body: Center(child: Text('Template details not found')),
        );
      },
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

    // Creative Details Route
    GoRoute(
      path: '/creative-details',
      name: 'creative-details',
      builder: (context, state) {
        final extra = state.extra;
        CreativeModel? creative;
        if (extra is CreativeModel) {
          creative = extra;
        } else if (extra is Map && extra['creative'] is CreativeModel) {
          creative = extra['creative'] as CreativeModel;
        }
        if (creative != null) {
          return CreativeDetailsScreen(creative: creative);
        }
        return const Scaffold(
          body: Center(child: Text('Creative details not found')),
        );
      },
    ),

    // Service Details Route
    GoRoute(
      path: '/service-details',
      name: 'service-details',
      builder: (context, state) {
        final extra = state.extra;
        ServiceModel? service;
        if (extra is ServiceModel) {
          service = extra;
        } else if (extra is Map && extra['service'] is ServiceModel) {
          service = extra['service'] as ServiceModel;
        }
        if (service != null) {
          return ServiceDetailsScreen(service: service);
        }
        return const Scaffold(
          body: Center(child: Text('Service details not found')),
        );
      },
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

    // Upload Service Route
    GoRoute(
      path: '/upload-service',
      name: 'upload-service',
      builder: (context, state) => const UploadServiceScreen(),
    ),

    // Billboard Marketplace Route
    GoRoute(
      path: '/billboard-marketplace',
      name: 'billboard-marketplace',
      builder: (context, state) => const BillboardMarketplaceScreen(),
    ),

    // Upload/Edit Billboard Route
    GoRoute(
      path: '/upload-billboard',
      name: 'upload-billboard',
      builder: (context, state) {
        final extra = state.extra is Map ? (state.extra as Map) : const {};
        final isUpdate = extra['isUpdate'] == true;
        final billboard = extra['billboard'] is BillboardModel
            ? extra['billboard'] as BillboardModel
            : null;
        return UploadBillboardScreen(
          isUpdate: isUpdate,
          billboard: billboard,
        );
      },
    ),

    // Billboard Details Route
    GoRoute(
      path: '/billboard-details',
      name: 'billboard-details',
      builder: (context, state) {
        final extra = state.extra;
        BillboardModel? billboard;
        if (extra is BillboardModel) {
          billboard = extra;
        } else if (extra is Map && extra['billboard'] is BillboardModel) {
          billboard = extra['billboard'] as BillboardModel;
        }
        if (billboard != null) {
          return BillboardDetailsScreen(billboard: billboard);
        }
        return const Scaffold(
          body: Center(child: Text('Billboard details not found')),
        );
      },
    ),

    // Billboard Orders Route
    GoRoute(
      path: '/billboard-orders',
      name: 'billboard-orders',
      builder: (context, state) {
        final extra = state.extra is Map ? (state.extra as Map) : const {};
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

    // Upload/Edit Wall Route
    GoRoute(
      path: '/upload-wall',
      name: 'upload-wall',
      builder: (context, state) {
        final extra = state.extra is Map ? (state.extra as Map) : const {};
        final isUpdate = extra['isUpdate'] == true;
        final wall =
            extra['wall'] is WallModel ? extra['wall'] as WallModel : null;
        return UploadWallScreen(
          isUpdate: isUpdate,
          wall: wall,
        );
      },
    ),

    // Wall Details Route
    GoRoute(
      path: '/wall-details',
      name: 'wall-details',
      builder: (context, state) {
        final extra = state.extra;
        WallModel? wall;
        if (extra is WallModel) {
          wall = extra;
        } else if (extra is Map && extra['wall'] is WallModel) {
          wall = extra['wall'] as WallModel;
        }
        if (wall != null) {
          return WallDetailsScreen(wall: wall);
        }
        return const Scaffold(
          body: Center(child: Text('Wall details not found')),
        );
      },
    ),

    // Screen Marketplace Route
    GoRoute(
      path: '/screen-marketplace',
      name: 'screen-marketplace',
      builder: (context, state) => const ScreenMarketplaceScreen(),
    ),

    // Upload/Edit Screen Route
    GoRoute(
      path: '/upload-screen',
      name: 'upload-screen',
      builder: (context, state) {
        final extra = state.extra is Map ? (state.extra as Map) : const {};
        final isUpdate = extra['isUpdate'] == true;
        final screen =
            extra['screen'] is ScreenModel ? extra['screen'] as ScreenModel : null;
        return UploadScreenScreen(
          isUpdate: isUpdate,
          screen: screen,
        );
      },
    ),

    // Screen Details Route
    GoRoute(
      path: '/screen-details',
      name: 'screen-details',
      builder: (context, state) {
        final extra = state.extra;
        ScreenModel? screen;
        if (extra is ScreenModel) {
          screen = extra;
        } else if (extra is Map && extra['screen'] is ScreenModel) {
          screen = extra['screen'] as ScreenModel;
        }
        if (screen != null) {
          return ScreenDetailsScreen(screen: screen);
        }
        return const Scaffold(
          body: Center(child: Text('Screen details not found')),
        );
      },
    ),

    // Vehicle Marketplace Route
    GoRoute(
      path: '/vehicle-marketplace',
      name: 'vehicle-marketplace',
      builder: (context, state) => const VehicleMarketplaceScreen(),
    ),

    // Upload/Edit Vehicle Route
    GoRoute(
      path: '/upload-vehicle',
      name: 'upload-vehicle',
      builder: (context, state) {
        final extra = state.extra is Map ? (state.extra as Map) : const {};
        final isUpdate = extra['isUpdate'] == true;
        final vehicle = extra['vehicle'] is VehicleModel
            ? extra['vehicle'] as VehicleModel
            : null;
        return UploadVehicleScreen(
          isUpdate: isUpdate,
          vehicle: vehicle,
        );
      },
    ),

    // Vehicle Details Route
    GoRoute(
      path: '/vehicle-details',
      name: 'vehicle-details',
      builder: (context, state) {
        final extra = state.extra;
        VehicleModel? vehicle;
        if (extra is VehicleModel) {
          vehicle = extra;
        } else if (extra is Map && extra['vehicle'] is VehicleModel) {
          vehicle = extra['vehicle'] as VehicleModel;
        }
        if (vehicle != null) {
          return VehicleDetailsScreen(vehicle: vehicle);
        }
        return const Scaffold(
          body: Center(child: Text('Vehicle details not found')),
        );
      },
    ),

    // All Ad Slots Route
    GoRoute(
      path: '/all-ad-slots',
      name: 'all-ad-slots',
      builder: (context, state) => const AllAdSlotsScreen(),
    ),

    // FAQ Route
    GoRoute(
      path: '/faqs',
      name: 'faqs',
      builder: (context, state) => const FaqScreen(),
    ),

    // Announcement Route
    GoRoute(
      path: '/announcements',
      name: 'announcements',
      builder: (context, state) => const AnnouncementScreen(),
    ),

    // Ad Slot Route (Reusable for Billboard/Wall/Screen)
    GoRoute(
      path: '/ad-slots',
      name: 'ad-slots',
      builder: (context, state) {
        final extra = state.extra is Map ? (state.extra as Map) : const {};
        final parentId = extra['parentId']?.toString() ?? '';
        final parentType = extra['parentType']?.toString() ?? 'billboard';
        final parentName = extra['parentName']?.toString() ??
            extra['billboardTitle']?.toString() ??
            '';
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
        final extra = state.extra is Map ? (state.extra as Map) : const {};
        final parentId = extra['parentId']?.toString() ?? '';
        final parentType = extra['parentType']?.toString() ?? 'billboard';
        final parentName = extra['parentName']?.toString() ?? '';
        final isUpdate = extra['isUpdate'] == true;
        final existingSlot = extra['existingSlot'];

        return CreateAdSlotScreen(
          parentId: parentId,
          parentType: parentType,
          parentName: parentName,
          isUpdate: isUpdate,
          existingSlot: existingSlot,
        );
      },
    ),

    // Ad Campaign Route (Orders/Campaigns for Billboard/Wall/Screen)
    GoRoute(
      path: '/ad-campaigns',
      name: 'ad-campaigns',
      builder: (context, state) {
        final extra = state.extra is Map ? (state.extra as Map) : const {};
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
        final extra = state.extra is Map ? (state.extra as Map) : const {};
        final billboardTitle =
            extra['billboardTitle']?.toString() ?? 'Billboard';
        return AdsSlotsScreen(billboardTitle: billboardTitle);
      },
    ),

    // KYC Routes
    GoRoute(
      path: '/kyc',
      name: 'kyc',
      builder: (context, state) => const KycLandingScreen(),
    ),
    GoRoute(
      path: '/kyc/form',
      name: 'kyc-form',
      builder: (context, state) => const KycFormScreen(),
    ),
    GoRoute(
      path: '/kyc/submit',
      name: 'kyc-submit',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is KycVerificationRequest) {
          return KycSubmissionScreen(request: extra);
        }
        return const KycFormScreen();
      },
    ),
    GoRoute(
      path: '/kyc/status',
      name: 'kyc-status',
      builder: (context, state) => const KycStatusScreen(),
    ),
    GoRoute(
      path: '/kyc/face',
      name: 'kyc-face',
      builder: (context, state) {
        final extra = state.extra is Map ? (state.extra as Map) : const {};
        final documentNumber = extra['documentNumber']?.toString() ?? '';
        return FaceVerificationScreen(documentNumber: documentNumber);
      },
    ),
    GoRoute(
      path: '/kyc/otp',
      name: 'kyc-otp',
      builder: (context, state) {
        final extra = state.extra is Map ? (state.extra as Map) : const {};
        final documentNumber = extra['documentNumber']?.toString() ?? '';
        return KycVerificationScreen(documentNumber: documentNumber);
      },
    ),
    GoRoute(
      path: '/kyc/gate',
      name: 'kyc-gate',
      builder: (context, state) {
        final extra = state.extra is Map ? (state.extra as Map) : const {};
        final requiredFor = extra['requiredFor']?.toString() ??
            extra['featureName']?.toString() ??
            'accessing this feature';
        final returnRoute = extra['returnRoute']?.toString();
        return KycGateScreen(
          requiredFor: requiredFor,
          returnRoute: returnRoute,
        );
      },
    ),
  ],
);

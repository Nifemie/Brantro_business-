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
import 'package:brantro_business/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:brantro_business/core/service/session_service.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final isLoggedIn = await SessionService.isLoggedIn();
    final isOnSplash = state.matchedLocation == '/';
    final isOnAuth = state.matchedLocation.startsWith('/signin') ||
        state.matchedLocation.startsWith('/signup') ||
        state.matchedLocation.startsWith('/intro') ||
        state.matchedLocation.startsWith('/forgot-password');

    // If user is logged in and trying to access splash or auth screens, redirect to home
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
        
        // Dashboard Route
        GoRoute(
          path: 'dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    ),
  ],
);

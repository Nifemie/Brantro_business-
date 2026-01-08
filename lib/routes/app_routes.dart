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
              path: 'account',
              name: 'account',
              builder: (context, state) => const UserAccount(),
            ),
            // Placeholder routes for other tabs can be added here
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
      ],
    ),
  ],
);

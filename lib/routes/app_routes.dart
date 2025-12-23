import 'package:go_router/go_router.dart';
import 'package:brantro/features/auth/presentation/splashscreen/splashscreen.dart';
import 'package:brantro/features/auth/presentation/introductory/intro_wrapper.dart';

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
      ],
    ),
  ],
);

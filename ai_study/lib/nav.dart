import 'package:cognix/providers/auth_provider.dart';
import 'package:cognix/screens/mobile/auth/mobile_signin.dart';
import 'package:cognix/screens/mobile/auth/mobile_signup.dart';
import 'package:cognix/screens/mobile/auth/mobile_welcome.dart';
import 'package:cognix/screens/mobile/features/mobile_home.dart';
import 'package:cognix/screens/mobile/features/premium_feature.dart';
import 'package:cognix/screens/mobile/onboarding/onboarding_screen.dart';
import 'package:cognix/screens/web/auth/web_signin.dart';
import 'package:cognix/screens/web/auth/web_signup.dart';
import 'package:cognix/screens/web/auth/web_welcome.dart';
import 'package:cognix/screens/web/features/web_home.dart';
import 'package:cognix/utils/platform_checker.dart';
import 'package:go_router/go_router.dart';
class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.onboarding, // Start with Onboarding
    refreshListenable: authProvider,
    redirect: (context, state) {
      // Auth Guard REMOVED: Allow anyone to access the app
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web
              ? const WebHome()
              : const MobileHome(),
        ),
      ),
      // Keep old auth routes just in case, or for future use
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web
              ? const WebWelcome()
              : const MobileWelcome(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authSignIn,
        name: 'auth_signin',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web
              ? const SignInWeb()
              : const SignInMobile(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authSignUp,
        name: 'auth_signup',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web
              ? const SignUpWeb()
              : const SignUpMobile(),
        ),
      ),
      GoRoute(
        path: AppRoutes.premiumFeature,
        name: 'premium_feature',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web
              ? const PremiumFeature()
              : const PremiumFeature(),
        ),
        )
    ],
  );
}

class AppRoutes {
  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String authSignIn = '/auth/signin';
  static const String authSignUp = '/auth/signup';
  static const String premiumFeature = '/premium-feature';
}

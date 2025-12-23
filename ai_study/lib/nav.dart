import 'package:cognix/providers/auth_provider.dart';
import 'package:cognix/screens/mobile/auth/mobile_signin.dart';
import 'package:cognix/screens/mobile/auth/mobile_signup.dart';
import 'package:cognix/screens/mobile/auth/mobile_welcome.dart';
import 'package:cognix/screens/mobile/features/mobile_home.dart';
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
    initialLocation: AppRoutes.home,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isAuthPath = loc.startsWith(AppRoutes.auth);
      if (!authProvider.isAuthenticated) {
        return isAuthPath ? null : AppRoutes.auth;
      }
      if (isAuthPath) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web
           ? const WebHome() : const MobileHome(),
        ),
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web ? const WebWelcome() : const MobileWelcome(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authSignIn,
        name: 'auth_signin',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web ? const SignInWeb() : const SignInMobile(),
        ),
      ),
      GoRoute(
        path: AppRoutes.authSignUp,
        name: 'auth_signup',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web ? const SignUpWeb() : const SignUpMobile(),
        ),
      ),
    ],
  );
}

class AppRoutes {
  static const String home = '/';
  static const String auth = '/auth';
  static const String authSignIn = '/auth/signin';
  static const String authSignUp = '/auth/signup';
}

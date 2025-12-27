import 'package:cognix/providers/auth_provider.dart';
import 'package:cognix/screens/mobile/auth/mobile_signin.dart';
import 'package:cognix/screens/mobile/auth/mobile_signup.dart';
import 'package:cognix/screens/mobile/auth/mobile_welcome.dart';
import 'package:cognix/screens/mobile/features/settings_screen.dart'
    show SettingsScreen;
import 'package:cognix/screens/mobile/main_screens/chat_screen.dart';
import 'package:cognix/screens/mobile/main_screens/home_screen.dart';
import 'package:cognix/screens/mobile/main_screens/file_generator.dart';
import 'package:cognix/screens/mobile/main_screens/resume_generator.dart';
import 'package:cognix/screens/mobile/main_screens/resume_history_screen.dart';
import 'package:cognix/screens/mobile/features/chat_history_screen.dart';
import 'package:cognix/screens/mobile/onboarding/onboarding_screen.dart';
import 'package:cognix/services/chat_history_service.dart';
import 'package:cognix/screens/web/auth/web_signin.dart';
import 'package:cognix/screens/web/auth/web_signup.dart';
import 'package:cognix/screens/web/auth/web_welcome.dart';
import 'package:cognix/screens/web/features/web_home.dart';
import 'package:cognix/utils/platform_checker.dart';
import 'package:cognix/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home, // Will be overridden by redirect
    refreshListenable: authProvider,
    redirect: (context, state) async {
      // Check if we need to show onboarding
      final prefs = await SharedPreferences.getInstance();
      final hasSeenOnboarding =
          prefs.getBool(AppConstants.onboardingSeenKey) ?? false;

      // If user hasn't seen onboarding and not already on onboarding screen
      if (!hasSeenOnboarding && state.matchedLocation != AppRoutes.onboarding) {
        return AppRoutes.onboarding;
      }

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
      GoRoute(
        path: AppRoutes.chat,
        name: 'chat',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web
              ? const WebHome()
              : PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    if (!didPop) {
                      context.go(AppRoutes.home);
                    }
                  },
                  child: ChattingScreen(session: state.extra as ChatSession?),
                ),
        ),
      ),
      GoRoute(
        path: AppRoutes.chatHistory,
        name: 'chat_history',
        pageBuilder: (context, state) => NoTransitionPage(
          child: ChatHistoryScreen(
            onChatSelected: (session) {
              context.push(AppRoutes.chat, extra: session);
            },
          ),
        ),
      ),

      // Keep old auth routes for future use
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
          path: AppRoutes.resume,
          name: 'resume',
          pageBuilder: (context, state) => NoTransitionPage(
                child: PlatformChecker.detectPlatform() == AppPlatform.web
                    ? const ResumeGenerator()
                    : PopScope(
                        canPop: false,
                        onPopInvoked: (didPop) {
                          if (!didPop) {
                            context.go(AppRoutes.home);
                          }
                        },
                        child: const ResumeGenerator(),
                      ),
              )),
      GoRoute(
        path: AppRoutes.resumeHistory,
        name: 'resume_history',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web
              ? const ResumeHistoryScreen()
              : PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    if (!didPop) {
                      context.go(AppRoutes.home);
                    }
                  },
                  child: const ResumeHistoryScreen(),
                ),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web
              ? const SettingsScreen()
              : PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    if (!didPop) {
                      context.go(AppRoutes.home);
                    }
                  },
                  child: const SettingsScreen(),
                ),
        ),
      ),

      GoRoute(
        path: AppRoutes.premiumFeature,
        name: 'premium_feature',
        pageBuilder: (context, state) => NoTransitionPage(
          child: PlatformChecker.detectPlatform() == AppPlatform.web
              ? const PremiumFeature()
              : PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    if (!didPop) {
                      context.go(AppRoutes.home);
                    }
                  },
                  child: const PremiumFeature(),
                ),
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
  static const String chat = '/chat';
  static const String chatHistory = '/chat-history';
  static const String settings = '/settings';
  static const String resume = '/resume';
  static const String resumeHistory = '/resume-history';
}

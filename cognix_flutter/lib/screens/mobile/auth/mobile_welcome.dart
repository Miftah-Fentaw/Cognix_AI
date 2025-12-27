import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cognix/config/router.dart';

class MobileWelcome extends StatelessWidget {
  const MobileWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.55),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/cognix.png",
                        height: 70,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Cognix',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Your AI Study Companion',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white70),
                  ),

                  const Spacer(),
                  Center(
                    child: Text(
                      "Let's Get Started",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Welcome 👋',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in or create an account to continue.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 9, 62, 83),
                                      Color.fromARGB(255, 5, 142, 255),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: FilledButton(
                                  onPressed: () =>
                                      context.go(AppRoutes.authSignIn),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Sign In'),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () =>
                                    context.go(AppRoutes.authSignUp),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white70),
                                ),
                                child: const Text('Sign Up'),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: const [
                            Expanded(child: Divider(color: Colors.white38)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('or',
                                  style: TextStyle(color: Colors.white70)),
                            ),
                            Expanded(child: Divider(color: Colors.white38)),
                          ],
                        ),

                        const SizedBox(height: 16),

                        OutlinedButton.icon(
                          onPressed: () {
                          },
                          icon: Image.asset(
                            'assets/google.png',
                            height: 20,
                          ),
                          label: const Text('Continue with Google'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

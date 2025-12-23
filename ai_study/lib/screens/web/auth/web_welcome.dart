import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../nav.dart';

class WebWelcome extends StatelessWidget {
  const WebWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        Expanded(
          flex: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Welcome 👋', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Sign in to continue or create a new account.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 24),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                           Color.fromARGB(255, 9, 62, 83),
                           Color.fromARGB(255, 5, 142, 255),
                        ])
                      ),
                    child: FilledButton.icon(
                      onPressed: () => context.go(AppRoutes.authSignIn),
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: const Text('Sign In',style: TextStyle(color: Colors.white),),
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), foregroundColor: Colors.transparent,backgroundColor: Colors.transparent),
                    ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => context.go(AppRoutes.authSignUp),
                      icon: Icon(Icons.person_add_alt_1, color: Theme.of(context).colorScheme.primary),
                      label: const Text('Create Account'),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(48),
            // color: Theme.of(context).colorScheme.primaryContainer,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/cognix.png"))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                 Image.asset("assets/cognix.png",height: 50,),
                  const SizedBox(width: 16),
                  Text('Cognix', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer)),
                ]),
                const SizedBox(height: 24),
                Text('AI-powered academic assistant for the web', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                const SizedBox(height: 8),
                Text('Analyze, summarize, and quiz your notes instantly.', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.9))),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

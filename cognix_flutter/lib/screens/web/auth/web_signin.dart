import 'package:cognix/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cognix/config/router.dart';

class SignInWeb extends StatefulWidget {
  const SignInWeb({super.key});

  @override
  State<SignInWeb> createState() => _SignInWebState();
}

class _SignInWebState extends State<SignInWeb> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await context.read<AuthProvider>().signIn(_email.text.trim(), _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      body: Row(children: [
        Expanded(
          flex: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Sign In', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(labelText: 'Email', prefixIcon: const Icon(Icons.email_outlined), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        validator: (v) => (v == null || v.isEmpty) ? 'Enter email' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _password,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        validator: (v) => (v == null || v.length < 6) ? 'Min 6 chars' : null,
                      ),
                      const SizedBox(height: 20),
                      DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(colors: [
                           Color.fromARGB(255, 9, 62, 83),
                           Color.fromARGB(255, 5, 142, 255),
                        ],
                      ),
                      ),
                      child: FilledButton.icon(
                        onPressed: isLoading ? null : _submit,
                        icon: const Icon(Icons.login, color: Colors.white),
                        label: Text(isLoading ? 'Signing In...' : 'Sign In'),
                        style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16),foregroundColor: Colors.transparent,backgroundColor: Colors.transparent),
                      ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.authSignUp),
                        child: const Text("Don't have an account? Create one"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(48),
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
                Text('Welcome back', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

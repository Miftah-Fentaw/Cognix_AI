import 'package:cognix/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'config/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Builder(
        builder: (context) {
          final authProvider = context.read<AuthProvider>();
          final appRouter = AppRouter(authProvider);

          return MaterialApp.router(
            title: 'Cognix',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.system,

            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}

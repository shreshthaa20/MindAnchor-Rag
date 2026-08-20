import 'package:flutter/material.dart';
import 'features/home/home_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
 runApp(
    const ProviderScope(
      child: MindAnchorApp(),
    ),
  );
}

class MindAnchorApp extends StatelessWidget {
  const MindAnchorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindAnchor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, _) => const LoginScreen(),
      data: (user) => user == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}

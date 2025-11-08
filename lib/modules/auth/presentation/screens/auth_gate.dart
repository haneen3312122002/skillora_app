// lib/core/widgets/auth_gate.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/auth/presentation/providers/firebase/auth_state_provider.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/email_verfication.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/login_screen.dart';
import 'package:notes_tasks/core/widgets/app_navbar_container.dart'; // شاشتك الرئيسية
import 'package:notes_tasks/core/widgets/loading_indicator.dart';
import 'package:notes_tasks/core/widgets/error_view.dart';

/// Decides whether to show the app or the login screen based on auth state.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);

    return authAsync.when(
      // If we have a user, go to the main app container
      // inside data: (user)
      data: (user) {
        if (user == null) return const LoginScreen();
        // Block unverified users
        if (!(user.emailVerified)) {
          return const VerifyEmailScreen(); // 👈 شاشة جديدة أدناه
        }
        return const AppNavBarContainer();
      },

      // Small loader while Firebase initializes/loads session
      loading: () => const LoadingIndicator(withBackground: true),
      // Fallback on error → show login (and an error)
      error: (e, _) => Stack(
        children: [
          const LoginScreen(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ErrorView(message: e.toString(), fullScreen: false),
          )
        ],
      ),
    );
  }
}

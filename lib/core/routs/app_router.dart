// lib/core/router/go_router_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/providers/firebase/auth/auth_state_provider.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/login_screen.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/email_verfication.dart';
import 'package:notes_tasks/core/widgets/app_navbar_container.dart';
import 'package:notes_tasks/core/widgets/loading_indicator.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/register.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/reset_password.dart';
import 'package:notes_tasks/modules/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/modules/users/presentation/features/user_details/screens/user_section_details_view.dart';
import 'package:notes_tasks/modules/users/presentation/features/user_details/user_section_details_args.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);

  return GoRouter(
    //loading
    initialLocation: '/loading',

    routes: [
      //Loading
      GoRoute(
        path: '/loading',
        builder: (context, state) =>
            const LoadingIndicator(withBackground: true),
      ),

      //  Login
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      //  Verify email
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),

      //  Main app (AppNavBarContainer)
      GoRoute(
        path: '/',
        builder: (context, state) => const AppNavBarContainer(),
      ),
      GoRoute(
        path: '/reset-pass',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/user-section-details',
        builder: (context, state) {
          final args = state.extra as UserSectionDetailsArgs;

          return UserSectionDetailsView<AddressEntity>(
            title: args.title,
            provider: args.provider,
            mapper: args.mapper,
          );
        },
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],

    redirect: (context, state) {
      // current state of the user:
      final loc = state.fullPath;

      final isOnLogin = loc == '/login';
      final isOnVerifyEmail = loc == '/verify-email';
      final isOnLoading = loc == '/loading';

      // 1️ Loading state → always go to /loading
      if (authAsync.isLoading) {
        if (!isOnLoading) return '/loading';
        return null;
      }

      // 2️ Error state → show login (you can later pass error via extra/params)
      if (authAsync.hasError) {
        if (!isOnLogin) return '/login';
        return null;
      }

      final user = authAsync.value; // User? from Firebase

      // 3️ Not logged in
      if (user == null) {
        if (!isOnLogin) return '/login';
        return null;
      }

      // 4️ Logged in but email NOT verified → must go to /verify-email
      if (!user.emailVerified) {
        if (!isOnVerifyEmail) return '/verify-email';
        return null;
      }

      // 5️ Logged in + verified:
      if (isOnLogin || isOnVerifyEmail || isOnLoading) {
        return '/';
      }

      // otherwise, stay on current screen
      return null;
    },
  );
});

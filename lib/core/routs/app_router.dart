import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/providers/firebase/auth/auth_state_provider.dart';
import 'package:notes_tasks/core/routs/app_routes.dart';
import 'package:notes_tasks/core/widgets/app_navbar_container.dart';
import 'package:notes_tasks/core/widgets/loading_indicator.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/login_screen.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/email_verfication.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/register.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/reset_password.dart';
import 'package:notes_tasks/modules/task/presentation/screens/task_screen.dart';
import 'package:notes_tasks/modules/post/presentation/screens/post_screen.dart';
import 'package:notes_tasks/modules/users/presentation/features/user_list/screens/users_list_screen.dart';
import 'package:notes_tasks/modules/cart/presentation/screens/cart_screen.dart';
import 'package:notes_tasks/modules/profile/presentation/screens/profile_screen.dart';
import 'package:notes_tasks/modules/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/modules/users/presentation/features/user_details/screens/user_section_details_view.dart';
import 'package:notes_tasks/modules/users/presentation/features/user_details/user_section_details_args.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.loading,

    routes: [
      //  Loading
      GoRoute(
        path: AppRoutes.loading,
        builder: (context, state) =>
            const LoadingIndicator(withBackground: true),
      ),

      //  Auth routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) => const VerifyEmailScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return AppNavBarContainer(
            child: child,
          );
        },
        routes: [
          // Tabs:
          GoRoute(
            path: AppRoutes.home, //
            builder: (context, state) => const TaskListScreen(),
          ),
          GoRoute(
            path: AppRoutes.posts,
            builder: (context, state) => const PostListScreen(),
          ),
          GoRoute(
            path: AppRoutes.users,
            builder: (context, state) => const UsersListScreen(),
          ),
          GoRoute(
            path: AppRoutes.cart,
            builder: (context, state) => const FirstCartScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),

          GoRoute(
            path: AppRoutes.userSectionDetails,
            builder: (context, state) {
              final args = state.extra as UserSectionDetailsArgs;

              return UserSectionDetailsView<AddressEntity>(
                title: args.title,
                provider: args.provider,
                mapper: args.mapper,
              );
            },
          ),
        ],
      ),
    ],
//auth
    redirect: (context, state) {
      final loc = state.uri.toString();

      final isOnLoading = loc == AppRoutes.loading;
      final isOnLogin = loc == AppRoutes.login;
      final isOnRegister = loc == AppRoutes.register;
      final isOnResetPassword = loc == AppRoutes.resetPassword;
      final isOnVerifyEmail = loc == AppRoutes.verifyEmail;

      final isInShell = loc == AppRoutes.home ||
          loc == AppRoutes.posts ||
          loc == AppRoutes.users ||
          loc == AppRoutes.cart ||
          loc == AppRoutes.profile ||
          loc == AppRoutes.userSectionDetails;

      if (authAsync.isLoading) {
        if (!isOnLoading) return AppRoutes.loading;
        return null;
      }

      if (authAsync.hasError) {
        if (!isOnLogin) return AppRoutes.login;
        return null;
      }

      final user = authAsync.value; //

      if (user == null) {
        // allow public auth routes:
        if (isOnLogin || isOnRegister || isOnResetPassword) {
          return null; // stay where you are
        }

        if (isInShell || isOnVerifyEmail) {
          return AppRoutes.login;
        }

        return null;
      }

      if (!user.emailVerified) {
        if (!isOnVerifyEmail) return AppRoutes.verifyEmail;
        return null;
      }

      if (isOnLogin || isOnRegister || isOnResetPassword || isOnLoading) {
        return AppRoutes.home;
      }

      return null;
    },
  );
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/app/layouts/app_layouts.dart';
import 'package:notes_tasks/core/app/routes/routes_helpers.dart';
import 'package:notes_tasks/core/session/providers/auth_state_provider.dart';
import 'package:notes_tasks/core/session/providers/user_role_provider.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';

// Auth screens
import 'package:notes_tasks/modules/auth/presentation/screens/login_screen.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/email_verfication.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/register.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/reset_password.dart';

// Chat
import 'package:notes_tasks/modules/chat/presentation/screens/chat_details_page.dart';
import 'package:notes_tasks/modules/chat/presentation/screens/chats_list_page.dart';

// Home + categories
import 'package:notes_tasks/modules/home/presentation/screens/home_screen.dart';
import 'package:notes_tasks/modules/home/presentation/screens/jobs_by_category_page.dart';

// Job details
import 'package:notes_tasks/modules/job/presentation/widgets/job_details_page.dart';

// Notifications
import 'package:notes_tasks/modules/notifications/presentation/screens/notifications_page.dart';

// Profile + project details
import 'package:notes_tasks/modules/profile/presentation/screens/profile_screen.dart';
import 'package:notes_tasks/modules/profile_projects/presentation/widgets/project_detail_page.dart';

// Proposals
import 'package:notes_tasks/modules/propsal/presentation/screens/client/client_job_proposals_section.dart';
import 'package:notes_tasks/modules/propsal/presentation/screens/client/client_proposals_page.dart';
import 'package:notes_tasks/modules/propsal/presentation/screens/freelancer/freelancer_proposals_section.dart';
import 'package:notes_tasks/modules/propsal/presentation/screens/proposal_details_page.dart';

// Settings
import 'package:notes_tasks/modules/settings/presentation/screens/change_password_screen.dart';
import 'package:notes_tasks/modules/settings/presentation/screens/settings_screen.dart';
import 'package:notes_tasks/modules/users/presentation/screens/user_public_profile_screen.dart';

// Users

/// ✅ IMPORTANT:
/// Keys must be top-level so they are created once only.
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _adminShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'adminShell');

final GlobalKey<NavigatorState> _clientShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'clientShell');

final GlobalKey<NavigatorState> _freelancerShellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'freelancerShell');

final goRouterProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);
  final roleAsync = ref.watch(userRoleProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.loading,
    routes: [
      // ===========================================================
      // CORE / LOADING
      // ===========================================================
      GoRoute(
        path: '${AppRoutes.publicUserProfile}/:id',
        builder: (context, state) {
          final userId = state.pathParameters['id']!;
          return UserPublicProfileScreen(uid: userId);
        },
      ),

      GoRoute(
        path: AppRoutes.loading,
        builder: (_, __) => const LoadingIndicator(withBackground: true),
      ),

      // ===========================================================
      // AUTH
      // ===========================================================
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (_, __) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (_, __) => const VerifyEmailScreen(),
      ),

      // ===========================================================
      // SETTINGS (outside shell)
      // ===========================================================
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (_, __) => const ChangePasswordScreen(),
      ),

      // ===========================================================
      // SHARED / DETAILS (outside shell)
      // ===========================================================
      GoRoute(
        path: AppRoutes.jobsByCategory,
        builder: (context, state) {
          final args = state.extra as JobsByCategoryArgs;
          return JobsByCategoryPage(
            category: args.category,
            titleLabel: args.titleLabel,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.jobDetails,
        builder: (context, state) {
          final args = state.extra as JobDetailsArgs;
          return JobDetailsPage(mode: args.mode, jobId: args.jobId);
        },
      ),
      GoRoute(
        path: AppRoutes.projectDetails,
        name: AppRoutes.projectDetails,
        builder: (context, state) {
          final args = state.extra as ProjectDetailsArgs;
          return ProjectDetailsPage(project: args.project, mode: args.mode);
        },
      ),
      GoRoute(
        path: AppRoutes.clientProposals,
        builder: (context, state) {
          final args = state.extra as ClientProposalsArgs;
          return ClientJobProposalsPage(jobId: args.jobId);
        },
      ),
      GoRoute(
        path: AppRoutes.proposalDetails,
        builder: (context, state) {
          final args = state.extra as ProposalDetailsArgs;
          return ProposalDetailsPage(
              proposalId: args.proposalId, mode: args.mode);
        },
      ),

      // Chat details
      GoRoute(
        path: '${AppRoutes.chatDetails}/:id',
        builder: (context, state) {
          final chatId = state.pathParameters['id']!;
          return ChatDetailsScreen(chatId: chatId);
        },
      ),
// ===========================================================
// ADMIN SHELL
// ===========================================================
      ShellRoute(
        navigatorKey: _adminShellNavigatorKey,
        builder: (_, __, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '${AppRoutes.adminUserProfile}/:id',
            builder: (context, state) {
              final userId = state.pathParameters['id']!;
              return ProfileScreen(viewedUid: userId); // ✅ نمرر uid
            },
          ),
          GoRoute(
            path: AppRoutes.adminHome,
            builder: (_, __) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.adminDashboard,
            builder: (_, __) => const HomePage(),
          ),
        ],
      ),

      // ===========================================================
      // CLIENT SHELL
      // ===========================================================
      ShellRoute(
        navigatorKey: _clientShellNavigatorKey,
        builder: (_, __, child) => ClientShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.clientHome,
            builder: (_, __) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.clientNotifications,
            builder: (_, __) => const NotificationsPage(),
          ),
          GoRoute(
            path: AppRoutes.clientChats,
            builder: (_, __) => const ChatsListScreen(),
          ),
          GoRoute(
            path: AppRoutes.clientProfile,
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),

      // ===========================================================
      // FREELANCER SHELL
      // ===========================================================
      ShellRoute(
        navigatorKey: _freelancerShellNavigatorKey,
        builder: (_, __, child) => FreelancerShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.freelanceHome,
            builder: (_, __) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.freelancerNotifications,
            builder: (_, __) => const NotificationsPage(),
          ),
          GoRoute(
            path: AppRoutes.freelancerProposals,
            builder: (_, __) => const FreelancerProposalsListPage(),
          ),
          GoRoute(
            path: AppRoutes.freelancerChats,
            builder: (_, __) => const ChatsListScreen(),
          ),
          GoRoute(
            path: AppRoutes.freelancerProfile,
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),
    ],

    // ===========================================================
    // REDIRECT
    // ===========================================================
    redirect: (context, state) {
      final loc = state.uri.path;

      // If user is intentionally switching accounts, let them stay on login.
      if (isSwitchLogin(state)) return null;

      // 1) Auth is still loading -> show loading screen.
      if (authAsync.isLoading) {
        return isLoadingRoute(loc) ? null : AppRoutes.loading;
      }
      if (authAsync.hasError) return AppRoutes.login;

      final user = authAsync.value;

      // 2) Not logged in -> allow only auth routes + reset password.
      if (user == null) {
        final canStay = isAuthRoute(loc) || isResetPasswordRoute(loc);
        return canStay ? null : AppRoutes.login;
      }

      // 3) Email not verified -> force verify screen.
      if (!user.emailVerified && !isVerifyEmailRoute(loc)) {
        return AppRoutes.verifyEmail;
      }

      // 4) Role still loading -> keep showing loading.
      if (roleAsync.isLoading) {
        return isLoadingRoute(loc) ? null : AppRoutes.loading;
      }
      if (roleAsync.hasError) return AppRoutes.login;

      final role = roleAsync.value ?? UserRole.client;

      // 5) If we are on verify screen but user is verified now -> go home.
      if (user.emailVerified && isVerifyEmailRoute(loc)) {
        final target = homeForRole(role);
        return (loc == target) ? null : target;
      }

      // 6) Logged-in user should not hang around on auth/loading/root.
      final shouldKickToHome = (isAuthRoute(loc) && !isSwitchLogin(state)) ||
          isLoadingRoute(loc) ||
          (loc == '/' && !isResetPasswordRoute(loc));

      if (shouldKickToHome) {
        final target = homeForRole(role);
        return (loc == target) ? null : target;
      }

      // 7) Shell protection per role (details pages are allowed outside the shell).
      if (!allowOutsideShell(loc)) {
        final okForRole = isRoleShellPath(role, loc);
        if (!okForRole) {
          final target = homeForRole(role);
          return (loc == target) ? null : target;
        }
      }

      return null;
    },
  );
});

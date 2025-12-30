import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routs/app_routes.dart';
import 'package:notes_tasks/core/app/layouts/app_layouts.dart';
import 'package:notes_tasks/core/features/auth/providers/auth_state_provider.dart';
import 'package:notes_tasks/core/features/auth/providers/user_role_provider.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';

import 'package:notes_tasks/modules/auth/presentation/screens/login_screen.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/email_verfication.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/register.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/reset_password.dart';

import 'package:notes_tasks/modules/chat/presentation/screens/chat_details_page.dart';
import 'package:notes_tasks/modules/chat/presentation/screens/chats_list_page.dart';

import 'package:notes_tasks/modules/home/presentation/screens/home_screen.dart';
import 'package:notes_tasks/modules/home/presentation/screens/jobs_by_category_page.dart';

import 'package:notes_tasks/modules/job/presentation/widgets/job_details_page.dart';
import 'package:notes_tasks/modules/notifications/presentation/screens/notifications_page.dart';

import 'package:notes_tasks/modules/profile/presentation/screens/profile_screen.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/project/project_deatil_page.dart';

import 'package:notes_tasks/modules/propseles/presentation/screens/client/client_job_proposals_section.dart';
import 'package:notes_tasks/modules/propseles/presentation/screens/client/client_proposals_page.dart';
import 'package:notes_tasks/modules/propseles/presentation/screens/freelancer/freelancer_proposals_section.dart';
import 'package:notes_tasks/modules/propseles/presentation/screens/proposal_details_page.dart';

import 'package:notes_tasks/modules/settings/presentation/screens/change_password_screen.dart';
import 'package:notes_tasks/modules/settings/presentation/screens/settings_screen.dart';

import 'package:notes_tasks/modules/users/presentation/features/user_details/screens/user_section_details_view.dart';
import 'package:notes_tasks/modules/users/presentation/features/user_details/user_section_details_args.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);
  final roleAsync = ref.watch(userRoleProvider);

  return GoRouter(
    initialLocation: AppRoutes.loading,
    routes: [
      // ✅ Routes برا الـShell (تفاصيل/صفحات مشتركة)
      GoRoute(
        path: AppRoutes.loading,
        builder: (_, __) => const LoadingIndicator(withBackground: true),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
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
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (_, __) => const ChangePasswordScreen(),
      ),
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
      GoRoute(
        path: AppRoutes.userSectionDetails,
        builder: (_, state) {
          final args = state.extra as UserSectionDetailsArgs;
          return UserSectionDetailsView(
            title: args.title,
            provider: args.provider,
            mapper: args.mapper,
          );
        },
      ),
      GoRoute(
        path: '${AppRoutes.chatDetails}/:id',
        builder: (context, state) {
          final chatId = state.pathParameters['id']!;
          return ChatDetailsScreen(chatId: chatId);
        },
      ),

      // ✅ Client Shell (كل اللي بدك يطلع معه NavBar لازم يكون هون)
      ShellRoute(
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

      // ✅ Freelancer Shell
      ShellRoute(
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

      // ✅ Admin (لو بدك Shell للأدمن لاحقًا)
    ],
    redirect: (context, state) {
      final loc = state.uri.path;
      final isSwitchLogin =
          loc == AppRoutes.login && state.uri.queryParameters['switch'] == '1';

      final isAuthRoute = loc == AppRoutes.login ||
          loc == AppRoutes.register ||
          loc == AppRoutes.verifyEmail;

      final isResetPasswordRoute = loc == AppRoutes.resetPassword;
      final isLoadingRoute = loc == AppRoutes.loading;

      final isSharedDetails = loc == AppRoutes.userSectionDetails;
      final isSettingsRoute = loc == AppRoutes.settings;
      final isChangePasswordRoute = loc == AppRoutes.changePassword;
      final isProjectDetailsRoute = loc == AppRoutes.projectDetails;
      final isJobDetailsRoute = loc == AppRoutes.jobDetails;
      final isJobsByCategoryRoute = loc == AppRoutes.jobsByCategory;
      final isProposealRoute = loc == AppRoutes.proposalDetails;
      final isChatDetailsRoute = loc.startsWith('${AppRoutes.chatDetails}/');
      // ✅ Allow login page when switching accounts (even if already logged in)
      if (isSwitchLogin) return null;

      // ✅ 1) auth loading
      if (authAsync.isLoading) {
        return isLoadingRoute ? null : AppRoutes.loading;
      }
      if (authAsync.hasError) return AppRoutes.login;

      final user = authAsync.value;

      // ✅ 2) not logged in
      if (user == null) {
        if (!isAuthRoute && !isResetPasswordRoute) return AppRoutes.login;
        return null;
      }

      // ✅ 3) email not verified
      if (!user.emailVerified && loc != AppRoutes.verifyEmail) {
        return AppRoutes.verifyEmail;
      }

      // ✅ 4) role loading
      if (roleAsync.isLoading) {
        return isLoadingRoute ? null : AppRoutes.loading;
      }
      if (roleAsync.hasError) return AppRoutes.login;

      final role = roleAsync.value ?? UserRole.client;

      // ✅ 5) when leaving verify page after verification
      if (user.emailVerified && loc == AppRoutes.verifyEmail) {
        switch (role) {
          case UserRole.client:
            return AppRoutes.clientHome;
          case UserRole.freelancer:
            return AppRoutes.freelanceHome;
          case UserRole.admin:
            return AppRoutes.adminDashboard;
        }
      }

      // ✅ 6) if opened auth/loading/root
      if ((isAuthRoute && !isSwitchLogin) ||
          isLoadingRoute ||
          (loc == '/' && !isResetPasswordRoute)) {
        switch (role) {
          case UserRole.client:
            return AppRoutes.clientHome;
          case UserRole.freelancer:
            return AppRoutes.freelanceHome;
          case UserRole.admin:
            return AppRoutes.adminDashboard;
        }
      }

      // ✅ 7) protect shells: allow shared pages to open without forcing home
      final allowOutsideShell = isSharedDetails ||
          isSettingsRoute ||
          isResetPasswordRoute ||
          isChangePasswordRoute ||
          isProjectDetailsRoute ||
          isProposealRoute ||
          isJobsByCategoryRoute ||
          isJobDetailsRoute ||
          isChatDetailsRoute;

      if (!allowOutsideShell) {
        final isClient = loc.startsWith('/client');
        final isFreelancer = loc.startsWith('/freelancer');
        final isAdmin = loc.startsWith('/admin');

        if (role == UserRole.client && !isClient) return AppRoutes.clientHome;
        if (role == UserRole.freelancer && !isFreelancer)
          return AppRoutes.freelanceHome; // ✅ صح
        if (role == UserRole.admin && !isAdmin) return AppRoutes.adminDashboard;
      }

      return null;
    },
  );
});

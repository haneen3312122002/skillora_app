import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';

//redirect helpers
bool isLoadingRoute(String loc) => loc == AppRoutes.loading;

bool isResetPasswordRoute(String loc) => loc == AppRoutes.resetPassword;

bool isAuthRoute(String loc) =>
    loc == AppRoutes.login ||
    loc == AppRoutes.register ||
    loc == AppRoutes.verifyEmail;

bool isSwitchLogin(GoRouterState state) =>
    state.uri.path == AppRoutes.login &&
    state.uri.queryParameters['switch'] == '1';

bool isVerifyEmailRoute(String loc) => loc == AppRoutes.verifyEmail;

// Chat details includes an id, so it will start with /chatDetails/
bool isChatDetailsRoute(String loc) =>
    loc.startsWith('${AppRoutes.chatDetails}/');

bool isSharedDetailsRoute(String loc) => loc == AppRoutes.userSectionDetails;

bool isSettingsRoute(String loc) => loc == AppRoutes.settings;

bool isChangePasswordRoute(String loc) => loc == AppRoutes.changePassword;

bool isProjectDetailsRoute(String loc) => loc == AppRoutes.projectDetails;

bool isJobDetailsRoute(String loc) => loc == AppRoutes.jobDetails;

bool isJobsByCategoryRoute(String loc) => loc == AppRoutes.jobsByCategory;

bool isProposalDetailsRoute(String loc) => loc == AppRoutes.proposalDetails;

/// Pages that can be opened outside the shell (no bottom nav).
/// Usually details pages or settings pages that should not force a home redirect.
bool allowOutsideShell(String loc) {
  return isSharedDetailsRoute(loc) ||
      isSettingsRoute(loc) ||
      isResetPasswordRoute(loc) ||
      isChangePasswordRoute(loc) ||
      isProjectDetailsRoute(loc) ||
      isProposalDetailsRoute(loc) ||
      isJobsByCategoryRoute(loc) ||
      isJobDetailsRoute(loc) ||
      isChatDetailsRoute(loc);
}

String homeForRole(UserRole role) {
  switch (role) {
    case UserRole.client:
      return AppRoutes.clientHome;
    case UserRole.freelancer:
      return AppRoutes.freelanceHome;
    case UserRole.admin:
      return AppRoutes.adminDashboard;
  }
}

bool isRoleShellPath(UserRole role, String loc) {
  final isClientPath = loc.startsWith('/client');
  final isFreelancerPath = loc.startsWith('/freelancer');
  final isAdminPath = loc.startsWith('/admin');

  switch (role) {
    case UserRole.client:
      return isClientPath;
    case UserRole.freelancer:
      return isFreelancerPath;
    case UserRole.admin:
      return isAdminPath;
  }
}

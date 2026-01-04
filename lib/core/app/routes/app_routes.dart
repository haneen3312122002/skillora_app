class AppRoutes {
  // ===========================================================
  // 1) CORE / SYSTEM ROUTES
  // ===========================================================
  static const String loading = '/loading';

  // ===========================================================
  // 2) AUTH ROUTES
  // ===========================================================
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String resetPassword = '/reset-pass';

  // ===========================================================
  // 3) SHARED / DETAILS ROUTES
  // (صفحات بتفتح من أكثر من دور)
  // ===========================================================
  static const String jobsByCategory = '/jobsByCategory';
  static const String jobDetails = '/job-details';
  static const String proposalDetails = '/proposal-details';
  static const String projectDetails = '/project-details';
  static const String userSectionDetails = '/user-section-details';

  // Chat (تفاصيل شات بمعرّف)
  static const String chatDetails = '/chat';
  static String chatDetailsPath(String id) => '$chatDetails/$id';

  // ===========================================================
  // 4) SETTINGS
  // ===========================================================
  static const String settings = '/settings';
  static const String changePassword = '/change-password';

  // ===========================================================
  // 5) CLIENT ROUTES
  // ===========================================================
  static const String clientHome = '/client/home';
  static const String clientJobs = '/client/jobs';
  static const String clientProposals = '/client/proposals';
  static const String clientChats = '/client/chats';
  static const String clientNotifications = '/client/notifications';
  static const String clientProfile = '/client/profile';

  // ===========================================================
  // 6) FREELANCER ROUTES
  // ===========================================================
  static const String freelanceHome = '/freelancer/home';
  static const String freelancerJobs = '/freelancer/jobs';
  static const String freelancerProposals = '/freelancer/proposals';
  static const String freelancerChats = '/freelancer/chats';
  static const String freelancerNotifications = '/freelancer/notifications';
  static const String freelancerProfile = '/freelancer/profile';

  // ===========================================================
  // 7) ADMIN ROUTES
  // ===========================================================
  static const String adminHome = '/admin/home';
  static const String adminDashboard = '/admin/dashboard';
}

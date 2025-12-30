import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/app/routs/app_router.dart';
import 'package:notes_tasks/core/app/routs/app_routes.dart';
import 'package:notes_tasks/core/app/theme/app_theme.dart';
import 'package:notes_tasks/core/app/viewmodels/theme_viewmodel.dart';
import 'package:notes_tasks/core/data/remote/firebase/firebase_initializer.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/shared/widgets/animation/fade_in.dart';
import 'package:notes_tasks/core/shared/widgets/animation/slide_in.dart';
// ✅ Notifications
import 'package:notes_tasks/core/features/notifications/notifications_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AppFirebase.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'lib/core/l10n',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(goRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          title: 'Notes Tasks',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          // ✅ هنا الربط: لو المستخدم كبس إشعار → افتح الراوت
          builder: (context, routerChild) {
            final appChild = routerChild ?? const SizedBox.shrink();

            return NotificationsRouterBootstrap(
              router: router,
              child: FadeIn(
                duration: const Duration(milliseconds: 250),
                child: SlideIn(
                  from: const Offset(0, 20),
                  duration: const Duration(milliseconds: 250),
                  child: appChild,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// ✅ Widget تعمل init للإشعارات وتعمل navigation عند الضغط على notification
class NotificationsRouterBootstrap extends ConsumerStatefulWidget {
  final GoRouter router;
  final Widget child;

  const NotificationsRouterBootstrap({
    super.key,
    required this.router,
    required this.child,
  });

  @override
  ConsumerState<NotificationsRouterBootstrap> createState() =>
      _NotificationsRouterBootstrapState();
}

class _NotificationsRouterBootstrapState
    extends ConsumerState<NotificationsRouterBootstrap> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tryInit();
  }

  void _tryInit() {
    if (_started) return;

    final user = ref.read(firebaseAuthProvider).currentUser;
    if (user == null) return; // لسه ما في logged-in user

    _started = true;

    // ✅ عدّليها حسب مشروعك (أفضل تجيبيها من profile/role provider)
    // إذا عندك role جاهز من الستريم بدليه هون
    final bool isFreelancer = true;

    ref.read(notificationsServiceProvider).initForUser(
          uid: user.uid,
          isFreelancer: isFreelancer,
          onTap: (data) {
            final type = data['type']?.toString();

            // ✅ إشعار رسالة شات → افتح المحادثة
            if (type == 'chat_message') {
              final chatId = data['chatId']?.toString();
              if (chatId != null && chatId.isNotEmpty) {
                widget.router.push('${AppRoutes.chatDetails}/$chatId');
              }
              return;
            }

            // ✅ إشعار وظيفة جديدة (اختياري)
            if (type == 'job_created') {
              final jobId = data['refId']?.toString();
              if (jobId != null && jobId.isNotEmpty) {
                // مثال لو عندك شاشة job details:
                // widget.router.push('${AppRoutes.jobDetails}/$jobId');
              }
              return;
            }
          },
        );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

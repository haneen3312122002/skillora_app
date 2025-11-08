import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes_tasks/core/services/firebase/firebase_initializer.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/auth_gate.dart';

import 'firebase_options.dart';
import 'package:notes_tasks/core/theme/app_theme.dart';
import 'package:notes_tasks/core/theme/viewmodels/theme_viewmodel.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AppFirebase.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'lib/core/assets/lang',
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

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Notes Tasks',
          theme: AppTheme.lightTheme, // لازم تكون getters
          darkTheme: AppTheme.darkTheme, // لازم تكون getters
          themeMode: themeMode,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: AuthGate(),
        );
      },
    );
  }
}

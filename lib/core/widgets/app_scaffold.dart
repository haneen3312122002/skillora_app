import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/constants/spacing.dart';
import 'package:notes_tasks/core/providers/firebase/firebase_providers.dart';
import 'package:notes_tasks/core/theme/viewmodels/theme_viewmodel.dart';
import 'package:notes_tasks/modules/auth/presentation/screens/login_screen.dart'; // ✅ للانتقال بعد الخروج

class AppScaffold extends ConsumerWidget {
  final String? title;
  final Widget body;
  final bool centerTitle;
  final bool usePadding;
  final bool scrollable;
  final Widget? floatingActionButton;
  final Widget? bottomNavBar;
  final bool showLogout; // ✅ جديد
  final VoidCallback? onLogout; // ✅ لو بدك سلوك مخصص بعد الخروج

  const AppScaffold({
    this.title,
    required this.body,
    this.centerTitle = true,
    this.usePadding = true,
    this.scrollable = true,
    this.floatingActionButton,
    this.bottomNavBar,
    this.showLogout = false, // افتراضياً غير مفعلة
    this.onLogout,
    required List<IconButton>
        actions, // هذا مش مستخدم فعلياً بس نتركه لتوافق الكود
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);
    final authService = ref.read(authServiceProvider); // ✅ الوصول لخدمة الخروج

    IconData icon =
        themeMode == ThemeMode.dark ? Icons.wb_sunny : Icons.nightlight_round;

    final content = usePadding
        ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.screenVertical,
            ),
            child: body,
          )
        : body;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: title != null
          ? AppBar(
              centerTitle: centerTitle,
              title: Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.appBarTheme.foregroundColor,
                ),
              ),
              backgroundColor: theme.appBarTheme.backgroundColor,
              elevation: theme.appBarTheme.elevation,
              actions: [
                // 🌗 زر تبديل الثيم
                IconButton(
                  icon: Icon(icon),
                  onPressed: () {
                    if (themeMode == ThemeMode.dark) {
                      ref
                          .read(themeProvider.notifier)
                          .setTheme(ThemeMode.light);
                    } else {
                      ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
                    }
                  },
                ),
                // 🚪 زر تسجيل الخروج (اختياري)
                if (showLogout)
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                    onPressed: () async {
                      await authService.logout();
                      if (onLogout != null) {
                        onLogout!();
                      } else {
                        // الانتقال الافتراضي إلى شاشة تسجيل الدخول
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      }
                    },
                  ),
              ],
            )
          : null,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavBar,
      body: SafeArea(
        child: scrollable
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: content,
              )
            : content,
      ),
    );
  }
}

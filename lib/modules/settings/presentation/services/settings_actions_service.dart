import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/app/routes/app_routes.dart';

import 'package:notes_tasks/core/app/viewmodels/theme_viewmodel.dart';
import 'package:notes_tasks/modules/auth/domain/usecases/logout_usecase.dart';

class SettingsActionsService {
  const SettingsActionsService._();


  static void showLanguageSelectorBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text('settings_language_ar'.tr()),
                onTap: () {
                  context.setLocale(const Locale('ar'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text('settings_language_en'.tr()),
                onTap: () {
                  context.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  static void showThemeSelectorBottomSheet(
    BuildContext context,
    WidgetRef ref,
    ThemeMode current,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: current,
                title: Text('settings_theme_system'.tr()),
                onChanged: (value) {
                  if (value == null) return;
                  ref.read(themeProvider.notifier).setTheme(value);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: current,
                title: Text('settings_theme_light'.tr()),
                onChanged: (value) {
                  if (value == null) return;
                  ref.read(themeProvider.notifier).setTheme(value);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: current,
                title: Text('settings_theme_dark'.tr()),
                onChanged: (value) {
                  if (value == null) return;
                  ref.read(themeProvider.notifier).setTheme(value);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }


  static void navigateToResetPassword(BuildContext context) {
    context.push(AppRoutes.resetPassword);
  }

  static void navigateToChangePassword(BuildContext context) {
    context.push(AppRoutes.changePassword);
  }


  static Future<void> logoutFromSettings(
      BuildContext context, WidgetRef ref) async {
    final logout = ref.read(logoutUseCaseProvider);
    await logout();
    if (context.mounted) {
      context.pushReplacement('/login');
    }
  }
}
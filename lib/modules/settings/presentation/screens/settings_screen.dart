import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/session/providers/current_user_provider.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/app/viewmodels/theme_viewmodel.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_card.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_list_tile.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';

import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/get_profile_stream_provider.dart';
import 'package:notes_tasks/modules/settings/presentation/services/settings_actions_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUid = ref.watch(currentUserIdProvider);

    final profileAsync = myUid == null
        ? const AsyncValue<ProfileEntity?>.data(null)
        : ref.watch(profileStreamProvider(myUid));

    return profileAsync.when(
      data: (profile) => AppScaffold(
        title: 'settings_title'.tr(),
        body: _SettingsContent(profile: profile),
        showSettingsButton: false,
        actions: const [],
      ),
      loading: () => const AppScaffold(
        title: null,
        body: LoadingIndicator(withBackground: false),
        actions: [],
      ),
      error: (e, st) => AppScaffold(
        title: 'settings_title'.tr(),
        body: ErrorView(
          message: e.toString(),
          fullScreen: false,
        ),
        actions: const [],
      ),
    );
  }
}

class _SettingsContent extends ConsumerWidget {
  final ProfileEntity? profile;

  const _SettingsContent({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = context.locale;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.spaceMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'settings_section_account'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppSpacing.spaceSM),
            AppCard(
              child: Column(
                children: [
                  if (profile != null) ...[
                    AppListTile(
                        leading: Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: 'edit_name'.tr(),
                        subtitle: profile!.name,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {}),
                    const Divider(),
                    AppListTile(
                        leading: Icon(
                          Icons.email,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: 'edit_email'.tr(),
                        subtitle: profile!.email,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {}),
                    const Divider(),
                  ],
                  AppListTile(
                    leading: Icon(
                      Icons.lock,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: 'settings_change_password'.tr(),
                    subtitle: 'settings_change_password_hint'.tr(),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      SettingsActionsService.navigateToChangePassword(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.spaceLG),
            Text(
              'settings_section_app'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppSpacing.spaceSM),
            AppCard(
              child: Column(
                children: [
                  AppListTile(
                    leading: const Icon(Icons.language),
                    title: 'settings_language'.tr(),
                    subtitle: _buildLanguageSubtitle(locale),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        SettingsActionsService.showLanguageSelectorBottomSheet(
                      context,
                    ),
                  ),
                  const Divider(),
                  AppListTile(
                    leading: const Icon(Icons.color_lens),
                    title: 'settings_theme'.tr(),
                    subtitle: _buildThemeSubtitle(themeMode),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        SettingsActionsService.showThemeSelectorBottomSheet(
                      context,
                      ref,
                      themeMode,
                    ),
                  ),
                  const Divider(),
                  AppListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: 'settings_logout'.tr(),
                    subtitle: 'settings_logout_hint'.tr(),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await SettingsActionsService.logoutFromSettings(
                        context,
                        ref,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildLanguageSubtitle(Locale locale) {
    if (locale.languageCode == 'ar') {
      return 'settings_language_ar'.tr();
    } else {
      return 'settings_language_en'.tr();
    }
  }

  String _buildThemeSubtitle(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'settings_theme_system'.tr();
      case ThemeMode.light:
        return 'settings_theme_light'.tr();
      case ThemeMode.dark:
        return 'settings_theme_dark'.tr();
    }
  }
}

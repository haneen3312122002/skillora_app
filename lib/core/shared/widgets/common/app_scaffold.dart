import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/services/auth/account_switcher/account_switcher_sheet.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/app/routes/app_routes.dart';

class AppScaffold extends ConsumerWidget {
  final String? title;
  final Widget body;
  final bool centerTitle;
  final bool usePadding;
  final bool scrollable;
  final Widget? floatingActionButton;
  final Widget? bottomNavBar;

  final bool showSettingsButton;
  final bool showLogout;
  final VoidCallback? onLogout;

  final bool extendBodyBehindAppBar;
  final bool useSafearea;

  /// Actions مخصّصة تظهر في الـ AppBar
  final List<Widget> actions;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.centerTitle = true,
    this.usePadding = true,
    this.scrollable = true,
    this.floatingActionButton,
    this.bottomNavBar,
    this.showSettingsButton = true,
    this.showLogout = false,
    this.onLogout,
    this.extendBodyBehindAppBar = false,
    this.useSafearea = true,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authService = ref.read(authServiceProvider);

    final Widget content = usePadding
        ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.screenVertical,
            ),
            child: body,
          )
        : body;

    final Widget mainBody = scrollable
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: content,
          )
        : content;

    final List<Widget> appBarActions = [
      ...actions,
      if (showSettingsButton)
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'settings_title'.tr(),
          onPressed: () => context.push(AppRoutes.settings),
        ),
      if (showLogout)
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'logout'.tr(),
          onPressed: () async {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (_) => const AccountSwitcherSheet(),
            );
          },
        )
    ];

    return Scaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
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
              actions: appBarActions.isEmpty ? null : appBarActions,
            )
          : null,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavBar,
      body: useSafearea ? SafeArea(child: mainBody) : mainBody,
    );
  }
}

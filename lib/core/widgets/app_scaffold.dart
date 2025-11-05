import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/theme/viewmodels/theme_viewmodel.dart';
import '../constants/spacing.dart';

class AppScaffold extends ConsumerWidget {
  final String? title;
  final Widget body;
  final bool centerTitle;
  final bool usePadding;
  final bool scrollable;
  final Widget? floatingActionButton;
  final Widget? bottomNavBasr;

  const AppScaffold({
    this.title,
    this.bottomNavBasr,
    required this.body,
    this.centerTitle = true,
    this.usePadding = true,
    this.scrollable = true,
    this.floatingActionButton,
    required List<IconButton> actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeProvider);

    IconData icon;
    if (themeMode == ThemeMode.dark) {
      icon = Icons.wb_sunny; // Show sun when currently in dark
    } else {
      icon = Icons.nightlight_round; // Show moon when currently in light/system
    }

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
              ],
            )
          : null,

      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavBasr,

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

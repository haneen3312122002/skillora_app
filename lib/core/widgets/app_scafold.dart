import 'package:flutter/material.dart';
import '../constants/spacing.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool usePadding;
  final bool scrollable;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.centerTitle = true,
    this.usePadding = true,
    this.scrollable = true,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              title: Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.appBarTheme.foregroundColor,
                ),
              ),
              centerTitle: centerTitle,
              actions: actions,
              // ✅ لا تعيّن لون يدوي، خليه يأخذ من الثيم
              backgroundColor: theme.appBarTheme.backgroundColor,
              elevation: theme.appBarTheme.elevation,
            )
          : null,

      floatingActionButton: floatingActionButton,

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

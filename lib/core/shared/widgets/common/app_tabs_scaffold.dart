import 'package:flutter/material.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';

class AppTabsScaffold extends StatelessWidget {
  final String title;
  final List<Tab> tabs;
  final List<Widget> views;

  /// optional actions in appbar
  final List<Widget>? actions;

  const AppTabsScaffold({
    super.key,
    required this.title,
    required this.tabs,
    required this.views,
    this.actions,
  }) : assert(tabs.length == views.length);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: actions,
          bottom: TabBar(
            tabs: tabs,
            isScrollable: false,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceMD,
            vertical: AppSpacing.spaceSM,
          ),
          child: TabBarView(children: views),
        ),
      ),
    );
  }
}

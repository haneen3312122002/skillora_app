import 'package:flutter/material.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/modules/auth/presentation/account_switcher/account_switcher_sheet.dart';
import 'package:notes_tasks/modules/home/presentation/widgets/home_header.dart';

class HomeShell extends StatelessWidget {
  final String title;
  final String? subtitle;

  final TextEditingController? searchController;
  final bool showSearch;
  final String searchHint;

  final Widget child;
  final bool padChild;

  const HomeShell({
    super.key,
    required this.title,
    this.subtitle,
    this.searchController,
    required this.child,
    this.showSearch = true,
    this.searchHint = 'search',
    this.padChild = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = padChild
        ? Padding(
            padding: EdgeInsets.all(AppSpacing.spaceMD),
            child: child,
          )
        : child;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeHeader(
          onLogoutTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (_) => const AccountSwitcherSheet(),
            );
          },
          title: title,
          subtitle: subtitle,
          showSearch: showSearch,
          searchController: showSearch ? searchController : null,
          searchHint: searchHint,
        ),
        content,
      ],
    );
  }
}

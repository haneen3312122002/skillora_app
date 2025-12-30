import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/widgets/common/app_tabs_scaffold.dart';
import 'package:notes_tasks/modules/home/presentation/widgets/jobs_tab_list.dart';

import 'package:notes_tasks/modules/job/presentation/providers/jobs_byid_stream_providers.dart';

class JobsByCategoryPage extends ConsumerWidget {
  final String category;
  final String? titleLabel;

  const JobsByCategoryPage({
    super.key,
    required this.category,
    this.titleLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ هنا لازم يكون عندك providers منفصلين أو فلترة من نفس stream
    final openAsync = ref.watch(jobsByCategoryOpenStreamProvider(category));
    final prevAsync = ref.watch(jobsByCategoryPreviousStreamProvider(category));

    return AppTabsScaffold(
      title: titleLabel ?? 'jobs'.tr(),
      tabs: [
        Tab(text: 'open'.tr()), // ضيف ترجمة open
        Tab(text: 'previous'.tr()), // ضيف ترجمة previous
      ],
      views: [
        JobsTabList(
          async: openAsync,
          onRefresh: () =>
              ref.invalidate(jobsByCategoryOpenStreamProvider(category)),
        ),
        JobsTabList(
          async: prevAsync,
          onRefresh: () =>
              ref.invalidate(jobsByCategoryPreviousStreamProvider(category)),
        ),
      ],
    );
  }
}

class JobsByCategoryArgs {
  final String category;
  final String? titleLabel;

  JobsByCategoryArgs({
    required this.category,
    this.titleLabel,
  });
}

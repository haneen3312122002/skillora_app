import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_card.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_infinite_list.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_list_tile.dart';

import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';
import 'package:notes_tasks/modules/job/presentation/widgets/job_details_page.dart';

class JobsTabList extends ConsumerWidget {
  final AsyncValue<List<JobEntity>> async;
  final VoidCallback onRefresh;

  const JobsTabList({
    super.key,
    required this.async,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return async.when(
      data: (jobs) {
        if (jobs.isEmpty) {
          return Center(child: Text('no_jobs_yet'.tr()));
        }

        return AppInfiniteList<JobEntity>(
          items: jobs,
          hasMore: false,
          onLoadMore: () {},
          onRefresh: () async => onRefresh(),
          padding: EdgeInsets.zero, // padding خارجي من tabs scaffold
          animateItems: true,
          itemBuilder: (context, job, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.spaceSM),
              child: AppCard(
                child: AppListTile(
                  leading: const Icon(Icons.work_outline),
                  title: job.title,
                  subtitle: job.description,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push(
                      AppRoutes.jobDetails,
                      extra: JobDetailsArgs(jobId: job.id, mode: PageMode.view),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: LoadingIndicator(withBackground: false),
      ),
      error: (_, __) => Center(
        child: ErrorView(
          message: 'something_went_wrong'.tr(),
          fullScreen: false,
          onRetry: onRefresh,
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/constants/job_categories.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/cards/category_card.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_section_card.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';
import 'package:notes_tasks/core/shared/widgets/common/profile_items_section.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_grid_view.dart';
import 'package:notes_tasks/core/shared/widgets/texts/app_text_link.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/modules/home/presentation/screens/jobs_by_category_page.dart';

import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';
import 'package:notes_tasks/modules/job/presentation/providers/jobs_stream_providers.dart';
import 'package:notes_tasks/modules/job/presentation/widgets/job_details_page.dart';

class FreelancerHome extends ConsumerWidget {
  const FreelancerHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = JobCategories.all;
    final jobsAsync = ref.watch(jobsFeedStreamProvider);

    return Padding(
      padding: EdgeInsets.all(AppSpacing.spaceMD),
      child: Column(
        children: [
          ProfileSectionCard(
            titleKey: 'all_categories', // ✅ key
            actions: [
              AppTextLink(
                textKey: 'see_all', // ✅ key
                onPressed: () {},
              ),
            ],
            child: AppGridView(
              itemCount: categories.length,
              minItemWidth: 110,
              childAspectRatio: 0.80,
              mainAxisSpacing: AppSpacing.spaceMD,
              crossAxisSpacing: AppSpacing.spaceMD,
              padding: EdgeInsets.symmetric(vertical: AppSpacing.spaceSM),
              itemBuilder: (context, index) {
                final c = categories[index];
                return CategoryTileCard(
                  title: c.label, // إذا بدك ترجمته: خلي label key
                  icon: c.icon,
                  onTap: () {
                    context.push(
                      AppRoutes.jobsByCategory,
                      extra: JobsByCategoryArgs(
                        category: c.id, // مهم: نفس القيمة المخزنة بالفايربيس
                        titleLabel: c.label,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: AppSpacing.spaceLG),
          jobsAsync.when(
            data: (jobs) => ProfileItemsSection<JobEntity>(
              items: jobs,
              titleKey: 'recent_jobs', // ✅ key
              emptyHintKey: 'no_jobs_yet', // ✅ key
              mode: PageMode.view,
              layout: ProfileItemsLayout.horizontalList,
              onAdd: () {},
              onTap: (context, job) {
                context.push(
                  AppRoutes.jobDetails,
                  extra: JobDetailsArgs(jobId: job.id, mode: PageMode.view),
                );
              },
              horizontalItemWidth: 260,
              horizontalListHeight: 340,
            ),
            loading: () => const SizedBox(
              height: 340,
              child: Center(
                  child: LoadingIndicator(
                withBackground: false,
              )),
            ),
            error: (e, st) => SizedBox(
              height: 340,
              child: Center(
                child: ErrorView(
                  message: 'something_went_wrong'.tr(),
                  fullScreen: false,
                  onRetry: () => ref.refresh(jobsFeedStreamProvider),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

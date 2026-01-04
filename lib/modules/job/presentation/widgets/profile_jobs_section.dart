import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/common/profile_items_section.dart';
import 'package:notes_tasks/core/shared/widgets/images/app_cover_images.dart';
import 'package:notes_tasks/core/shared/widgets/pages/app_bottom_sheet.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';

import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';
import 'package:notes_tasks/modules/job/presentation/providers/job_usecases_providers.dart';
import 'package:notes_tasks/modules/job/presentation/widgets/job_details_page.dart';
import 'package:notes_tasks/modules/job/presentation/widgets/job_form_widget.dart';

// ✅ NEW: local cover bytes provider
import 'package:notes_tasks/modules/job/presentation/viewmodels/job_cover_image_viewmodel.dart';

class ProfileJobsSection extends ConsumerWidget {
  final List<JobEntity> jobs;

  const ProfileJobsSection({
    super.key,
    required this.jobs,
  });

  String _fmtDate(DateTime? d) {
    if (d == null) return '-';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfileItemsSection<JobEntity>(
      items: jobs,
      titleKey: 'jobs_title',
      emptyHintKey: 'jobs_empty_hint',
      placeholderIcon: Icons.work_outline,

      // ✅ NEW: show cover image from local storage (SharedPreferences)
      coverBuilder: (context, ref, job) {
        final bytes = ref.watch(jobCoverImageViewModelProvider(job.id));
        return AppRectImage(
          imageUrl: job.imageUrl,
          bytes: bytes, // ✅ local first
          placeholderIcon: Icons.work_outline,
        );
      },
      // ✅ optional extra info under each tile
      extraInfoBuilder: (context, job) {
        final theme = Theme.of(context);
        final dim = theme.colorScheme.onSurface.withOpacity(.7);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (job.category.trim().isNotEmpty)
              Text(
                'Category: ${job.category}',
                style: AppTextStyles.caption.copyWith(color: dim),
              ),
            Text(
              'Status: ${job.isOpen ? "Open" : "Closed"}',
              style: AppTextStyles.caption.copyWith(color: dim),
            ),
            if (job.budget != null)
              Text(
                'Budget: ${job.budget!.toStringAsFixed(0)}',
                style: AppTextStyles.caption.copyWith(color: dim),
              ),
            Text(
              'Deadline: ${_fmtDate(job.deadline)}',
              style: AppTextStyles.caption.copyWith(color: dim),
            ),
          ],
        );
      },

      onAdd: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AppBottomSheet(child: JobFormWidget()),
        );
      },

      onTap: (context, job) {
        context.push(
          AppRoutes.jobDetails,
          extra: JobDetailsArgs(jobId: job.id, mode: PageMode.edit),
        );
      },

      onEdit: (ref, job) async {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => AppBottomSheet(child: JobFormWidget(initial: job)),
        );
      },

      onDelete: (ref, job) async {
        final deleteUseCase = ref.read(deleteJobUseCaseProvider);
        await deleteUseCase(job.id);
      },
    );
  }
}

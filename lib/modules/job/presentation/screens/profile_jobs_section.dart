import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/common/profile_items_section.dart';
import 'package:notes_tasks/core/shared/widgets/pages/app_bottom_sheet.dart';

import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';
import 'package:notes_tasks/modules/job/presentation/widgets/job_form_widget.dart';
import 'package:notes_tasks/modules/job/presentation/widgets/job_details_page.dart';
import 'package:notes_tasks/modules/job/presentation/providers/job_usecases_providers.dart';

class ProfileJobsSection extends ConsumerWidget {
  final List<JobEntity> jobs;

  const ProfileJobsSection({
    super.key,
    required this.jobs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfileItemsSection<JobEntity>(
      items: jobs,
      titleKey: 'jobs_title',
      emptyHintKey: 'jobs_empty_hint',
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

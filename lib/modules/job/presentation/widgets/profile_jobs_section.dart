import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/common/profile_items_section.dart';
import 'package:notes_tasks/core/shared/widgets/pages/app_bottom_sheet.dart';

import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';
import 'package:notes_tasks/modules/job/domain/failures/job_failure.dart';
import 'package:notes_tasks/modules/job/presentation/viewmodels/job_actions_viewmodel.dart';
import 'package:notes_tasks/modules/job/presentation/widgets/job_details_page.dart';
import 'package:notes_tasks/modules/job/presentation/widgets/job_form_widget.dart';

class ProfileJobsSection extends ConsumerWidget {
  final List<JobEntity> jobs;
  final bool canEdit; // ✅ نفس فكرة projects

  const ProfileJobsSection({
    super.key,
    required this.jobs,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ اسمع للأكشنز فقط لما المستخدم يقدر يعدّل
    if (canEdit) {
      ref.listen(jobActionsViewModelProvider, (prev, next) {
        next.when(
          loading: () {},
          error: (e, _) {
            final key =
                (e is JobFailure) ? e.messageKey : 'something_went_wrong';
            AppSnackbar.show(context, key.tr());
          },
          data: (_) {
            final wasLoading = prev?.isLoading ?? false;
            if (wasLoading) AppSnackbar.show(context, 'common_deleted'.tr());
          },
        );
      });
    }

    final actionsAsync = ref.watch(jobActionsViewModelProvider);
    final actionsVm = ref.read(jobActionsViewModelProvider.notifier);

    return ProfileItemsSection<JobEntity>(
      items: jobs,
      titleKey: 'jobs_title',
      emptyHintKey: 'jobs_empty_hint',

      // ✅ Add: يظهر فقط إذا canEdit=true
      onAdd: canEdit
          ? () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const AppBottomSheet(child: JobFormWidget()),
              );
            }
          : null,

      // ✅ التفاصيل: edit للمالك، view للزائر
      onTap: (context, job) {
        context.push(
          AppRoutes.jobDetails,
          extra: JobDetailsArgs(
            jobId: job.id,
            mode: canEdit ? PageMode.edit : PageMode.view,
          ),
        );
      },

      // ✅ Edit: فقط للمالك
      onEdit: canEdit
          ? (ref, job) async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) =>
                    AppBottomSheet(child: JobFormWidget(initial: job)),
              );
            }
          : null,

      // ✅ Delete: فقط للمالك
      onDelete: canEdit
          ? (ref, job) async {
              if (actionsAsync.isLoading) return;
              await actionsVm.deleteJob(job.id);
            }
          : null,
    );
  }
}

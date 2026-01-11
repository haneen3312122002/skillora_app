import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/details/details_info_group.dart';
import 'package:notes_tasks/core/shared/widgets/details/details_info_item.dart';
import 'package:notes_tasks/core/shared/widgets/details/details_section_title.dart';
import 'package:notes_tasks/core/shared/widgets/details/details_tags_block.dart';
import 'package:notes_tasks/core/shared/widgets/details/details_text_block.dart';
import 'package:notes_tasks/core/shared/widgets/pages/app_bottom_sheet.dart';
import 'package:notes_tasks/core/shared/widgets/pages/details_page.dart';
import 'package:notes_tasks/core/shared/widgets/tags/app_tags_wrap.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/modules/job/presentation/providers/jobs_byid_stream_providers.dart';

import 'package:notes_tasks/modules/job/presentation/viewmodels/job_cover_image_viewmodel.dart';
import 'package:notes_tasks/modules/job/presentation/services/job_image_helpers.dart';

import 'package:notes_tasks/modules/propsal/presentation/providers/proposals_stream_providers.dart';
import 'package:notes_tasks/modules/propsal/presentation/screens/client/client_job_proposals_section.dart';
import 'package:notes_tasks/modules/propsal/presentation/widgets/proposal_form_widget.dart';

import 'package:notes_tasks/modules/job/presentation/viewmodels/job_actions_viewmodel.dart';
import 'package:notes_tasks/modules/job/domain/failures/job_failure.dart';

// ----------------------------------------------------
// Args
// ----------------------------------------------------
class JobDetailsArgs {
  final String jobId;
  final PageMode mode;

  const JobDetailsArgs({required this.jobId, this.mode = PageMode.view});
}

// ----------------------------------------------------
// Page
// ----------------------------------------------------
class JobDetailsPage extends ConsumerWidget {
  final String jobId;
  final PageMode mode;

  const JobDetailsPage({
    super.key,
    required this.jobId,
    this.mode = PageMode.view,
  });

  bool get _canEditHeader => mode == PageMode.edit;
  bool get _isClient => mode == PageMode.edit;
  bool get _isFreelancer => mode == PageMode.view;

  String _fmtDate(DateTime? d) {
    if (d == null) return '-';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Widget _infoBlock({
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: AppSpacing.spaceXS),
        Text(value, style: AppTextStyles.body),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ listen once per build lifecycle (Riverpod handles it safely)
    ref.listen(jobActionsViewModelProvider, (prev, next) {
      // error
      next.when(
        loading: () {
          
        },
        
        error: (e, _) {
          final key = (e is JobFailure) ? e.messageKey : 'something_went_wrong';
          AppSnackbar.show(context, key.tr());
        },
        data: (_) {
          // success (optional)
          final wasLoading = prev?.isLoading ?? false;
          if (wasLoading) {
            AppSnackbar.show(context, 'common_saved'.tr());
          }
        },
      );
    });

    final jobAsync = ref.watch(jobByIdStreamProvider(jobId));

    return jobAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('Error: $e'))), // خليها زي ما عندك
      data: (job) {
        if (job == null) {
          return Scaffold(body: Center(child: Text('job_not_found'.tr())));
        }

        final hasDesc = job.description.trim().isNotEmpty;
        final hasSkills = job.skills.isNotEmpty;
        final hasCategory = job.category.trim().isNotEmpty;
        final hasJobUrl = (job.jobUrl ?? '').trim().isNotEmpty;
        final hasBudget = job.budget != null;

        final localCoverBytes =
            ref.watch(jobCoverImageViewModelProvider(job.id));

        final actionAsync = ref.watch(jobActionsViewModelProvider);
        final jobVm = ref.read(jobActionsViewModelProvider.notifier);
        final isToggling = actionAsync.isLoading;

        final canApply = _isFreelancer && job.isOpen;

        final myProposalAsync =
            ref.watch(myProposalForJobStreamProvider(job.id));

        final alreadyApplied = myProposalAsync.maybeWhen(
          data: (p) => p != null,
          orElse: () => false,
        );

        return AppDetailsPage(
          mode: mode,
          appBarTitleKey: 'job_details_title',
          coverImageUrl: job.imageUrl,
          coverBytes: localCoverBytes,
          showAvatar: false,
          title: job.title,
          subtitle: null,
          onChangeCover: _canEditHeader
              ? () => pickAndUploadJobCover(context, ref, jobId: job.id)
              : null,
          onChangeAvatar: null,

          // ✅ proposal button
          proposalButtonLabelKey: canApply
              ? (alreadyApplied ? 'already_applied' : 'make_proposal')
              : '',
          proposalButtonIcon: canApply ? Icons.send_outlined : null,
          onProposalPressed: (canApply && !alreadyApplied)
              ? () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => AppBottomSheet(
                      child: ProposalFormWidget(
                        jobId: job.id,
                        clientId: job.clientId,
                      ),
                    ),
                  );
                }
              : null,

          sections: [
            // ✅ Client controls (خليها زي ما هي بس داخل Card)
            if (_isClient) ...[
              DetailsSectionTitle('actions'.tr()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: isToggling
                        ? null
                        : () => jobVm.setOpen(job, !job.isOpen),
                    icon: isToggling
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(job.isOpen
                            ? Icons.lock_outline
                            : Icons.lock_open_outlined),
                    label:
                        Text(job.isOpen ? 'close_job'.tr() : 'open_job'.tr()),
                  ),
                  SizedBox(height: AppSpacing.spaceSM),
                  OutlinedButton.icon(
                    onPressed: () {
                      context.push(
                        AppRoutes.clientProposals,
                        extra: ClientProposalsArgs(jobId: job.id),
                      );
                    },
                    icon: const Icon(Icons.list_alt),
                    label: Text('view_proposals'.tr()),
                  ),
                ],
              ),
            ],

            // ✅ Info card
            DetailsSectionTitle('job_info'.tr()),
            DetailsInfoGroup(
              children: [
                if (hasCategory)
                  DetailsInfoItem(title: 'category'.tr(), value: job.category),
                DetailsInfoItem(
                  title: 'status'.tr(),
                  value: job.isOpen ? 'open'.tr() : 'closed'.tr(),
                ),
                if (hasBudget)
                  DetailsInfoItem(
                    title: 'budget'.tr(),
                    value: job.budget!.toStringAsFixed(0),
                  ),
                DetailsInfoItem(
                    title: 'deadline'.tr(), value: _fmtDate(job.deadline)),
                if (hasJobUrl)
                  DetailsInfoItem(
                      title: 'job_url'.tr(), value: job.jobUrl!.trim()),
              ],
            ),

            if (hasDesc)
              DetailsTextBlock(
                title: 'job_description_title'.tr(),
                text: job.description,
              ),

            if (hasSkills)
              DetailsTagsBlock(
                title: 'job_skills_label'.tr(),
                tags: job.skills,
              ),
          ],
        );
      },
    );
  }
}

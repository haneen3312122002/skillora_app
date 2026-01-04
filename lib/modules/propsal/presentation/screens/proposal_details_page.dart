import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/pages/details_page.dart';

import 'package:notes_tasks/modules/job/presentation/providers/jobs_byid_stream_providers.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/get_profile_stream_provider.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/users_stream_provider.dart';

import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_status.dart';
import 'package:notes_tasks/modules/propsal/presentation/providers/proposals_stream_providers.dart';
import 'package:notes_tasks/modules/propsal/presentation/viewmodels/proposal_actions_viewmodel.dart';

class ProposalDetailsArgs {
  final String proposalId;
  final PageMode mode;

  const ProposalDetailsArgs({
    required this.proposalId,
    this.mode = PageMode.view,
  });
}

/// helpers
Widget _infoBlock({required String title, required String value}) {
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

String _fmtMoney(double? v) => v == null ? '-' : v.toStringAsFixed(0);

String _fmtDate(DateTime? d) {
  if (d == null) return '-';
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

String _fmtStatus(ProposalStatus s) {
  switch (s) {
    case ProposalStatus.pending:
      return 'Pending';
    case ProposalStatus.accepted:
      return 'Accepted';
    case ProposalStatus.rejected:
      return 'Rejected';
  }
}

class ProposalDetailsPage extends ConsumerWidget {
  final String proposalId;
  final PageMode mode;

  const ProposalDetailsPage({
    super.key,
    required this.proposalId,
    this.mode = PageMode.view,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proposalAsync = ref.watch(proposalByIdStreamProvider(proposalId));
    final profileAsync = ref.watch(profileStreamProvider);

    return proposalAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (proposal) {
        if (proposal == null) {
          return Scaffold(body: Center(child: Text('proposal_not_found'.tr())));
        }

        // ✅ هون صح: بعد ما صار عندنا proposal
        final jobAsync = ref.watch(jobByIdStreamProvider(proposal.jobId));
        final clientAsync =
            ref.watch(userByIdStreamProvider(proposal.clientId));

        return profileAsync.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
          data: (profile) {
            final role = profile?.role ?? '';
            final isClient = role == 'client';

            return _ProposalDetailsBody(
              proposal: proposal,
              mode: mode,
              isClient: isClient,
              jobAsync: jobAsync,
              clientAsync: clientAsync,
            );
          },
        );
      },
    );
  }
}

class _ProposalDetailsBody extends ConsumerWidget {
  final ProposalEntity proposal;
  final PageMode mode;
  final bool isClient;

  final AsyncValue jobAsync;
  final AsyncValue clientAsync;

  const _ProposalDetailsBody({
    required this.proposal,
    required this.mode,
    required this.isClient,
    required this.jobAsync,
    required this.clientAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(proposalActionsViewModelProvider.notifier);

    final isPending = proposal.status == ProposalStatus.pending;
    final showClientDecisionButtons = isClient && isPending;

    // ✅ استخرج بيانات الكلاينت (Map) لو موجودة
    final clientMap = clientAsync.value as Map<String, dynamic>?;
    final clientName = (clientMap?['name'] ?? '-') as String;
    final clientPhotoUrl = clientMap?['photoUrl'] as String?;

    // ✅ استخرج بيانات الجوب (JobEntity?) لو موجودة
    final job = jobAsync.value; // غالباً JobEntity?
    // بما إنه AsyncValue<dynamic> فوق، خلينا نحميها:
    final jobTitle = (job as dynamic)?.title?.toString() ?? '-';
    final jobCategory = (job as dynamic)?.category?.toString() ?? '-';
    final jobBudget = (job as dynamic)?.budget as double?;
    final jobDeadline = (job as dynamic)?.deadline as DateTime?;

    return AppDetailsPage(
      mode: mode,
      appBarTitleKey: 'proposal_details_title',
      title: proposal.title,
      subtitle: _fmtStatus(proposal.status),
      coverImageUrl: proposal.imageUrl,
      coverBytes: null,
      showAvatar: true,
      avatarImageUrl: clientPhotoUrl,
      avatarBytes: null,
      sections: [
        // =========================
        // JOB
        // =========================
        Text('Job'.tr(),
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        SizedBox(height: AppSpacing.spaceSM),

        jobAsync.when(
          loading: () => const Text('Loading job...'),
          error: (e, _) => Text('Job error: $e'),
          data: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoBlock(title: 'Title', value: jobTitle),
              _infoBlock(title: 'Category', value: jobCategory),
              _infoBlock(title: 'Budget', value: _fmtMoney(jobBudget)),
              _infoBlock(title: 'Deadline', value: _fmtDate(jobDeadline)),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.spaceLG),

        // =========================
        // CLIENT
        // =========================
        Text('Client'.tr(),
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        SizedBox(height: AppSpacing.spaceSM),

        clientAsync.when(
          loading: () => const Text('Loading client...'),
          error: (e, _) => Text('Client error: $e'),
          data: (_) => _infoBlock(title: 'Name', value: clientName),
        ),

        SizedBox(height: AppSpacing.spaceLG),

        // =========================
        // PROPOSAL
        // =========================
        Text('Proposal'.tr(),
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        SizedBox(height: AppSpacing.spaceSM),

        _infoBlock(title: 'Status', value: _fmtStatus(proposal.status)),
        if (proposal.price != null)
          _infoBlock(title: 'Price', value: _fmtMoney(proposal.price)),
        if (proposal.durationDays != null)
          _infoBlock(title: 'Duration', value: '${proposal.durationDays} days'),

        SizedBox(height: AppSpacing.spaceSM),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('proposal_message'.tr(),
                style:
                    AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: AppSpacing.spaceSM),
            Text(proposal.coverLetter, style: AppTextStyles.body),
          ],
        ),

        if (showClientDecisionButtons) ...[
          SizedBox(height: AppSpacing.spaceLG),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => vm.reject(context, proposal.id),
                  child: Text('Reject'.tr()),
                ),
              ),
              SizedBox(width: AppSpacing.spaceSM),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => vm.accept(context, proposal.id),
                  child: Text('Accept'.tr()),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

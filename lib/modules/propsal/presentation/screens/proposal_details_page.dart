import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/pages/details_page.dart';

import 'package:notes_tasks/modules/job/presentation/providers/jobs_byid_stream_providers.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/get_profile_stream_provider.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/users_stream_provider.dart';

import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_status.dart';
import 'package:notes_tasks/modules/propsal/domain/failures/proposal_failure.dart';
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

String _fmtStatusKey(ProposalStatus s) {
  switch (s) {
    case ProposalStatus.pending:
      return 'proposal_status_pending';
    case ProposalStatus.accepted:
      return 'proposal_status_accepted';
    case ProposalStatus.rejected:
      return 'proposal_status_rejected';
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

  void _openChat(BuildContext context, String chatId) {
    // ✅ adjust if your route differs
    context.push('/chat/$chatId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ listen for action errors
    ref.listen(proposalActionsViewModelProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) {
          final key =
              (e is ProposalFailure) ? e.messageKey : 'something_went_wrong';
          AppSnackbar.show(context, key.tr());
          ref.read(proposalActionsViewModelProvider.notifier).reset();
        },
      );
    });

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
              onOpenChat: _openChat,
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

  final void Function(BuildContext context, String chatId) onOpenChat;

  const _ProposalDetailsBody({
    required this.proposal,
    required this.mode,
    required this.isClient,
    required this.jobAsync,
    required this.clientAsync,
    required this.onOpenChat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(proposalActionsViewModelProvider.notifier);
    final actions = ref.watch(proposalActionsViewModelProvider);

    final isPending = proposal.status == ProposalStatus.pending;
    final showClientDecisionButtons = isClient && isPending;

    final clientMap = clientAsync.value as Map<String, dynamic>?;
    final clientName = (clientMap?['name'] ?? '-') as String;
    final clientPhotoUrl = clientMap?['photoUrl'] as String?;

    final job = jobAsync.value;
    final jobTitle = (job as dynamic)?.title?.toString() ?? '-';
    final jobCategory = (job as dynamic)?.category?.toString() ?? '-';
    final jobBudget = (job as dynamic)?.budget as double?;
    final jobDeadline = (job as dynamic)?.deadline as DateTime?;

    final statusText = _fmtStatusKey(proposal.status).tr();

    return AppDetailsPage(
      mode: mode,
      appBarTitleKey: 'proposal_details_title',
      title: proposal.title,
      subtitle: statusText,
      coverImageUrl: proposal.imageUrl,
      coverBytes: null,
      showAvatar: true,
      avatarImageUrl: clientPhotoUrl,
      avatarBytes: null,
      sections: [
        Text('job'.tr(),
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        SizedBox(height: AppSpacing.spaceSM),
        jobAsync.when(
          loading: () => Text('loading'.tr()),
          error: (_, __) => Text('something_went_wrong'.tr()),
          data: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoBlock(title: 'label_title'.tr(), value: jobTitle),
              _infoBlock(title: 'label_category'.tr(), value: jobCategory),
              _infoBlock(
                  title: 'label_budget'.tr(), value: _fmtMoney(jobBudget)),
              _infoBlock(
                  title: 'label_deadline'.tr(), value: _fmtDate(jobDeadline)),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.spaceLG),
        Text('client'.tr(),
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        SizedBox(height: AppSpacing.spaceSM),
        clientAsync.when(
          loading: () => Text('loading'.tr()),
          error: (_, __) => Text('something_went_wrong'.tr()),
          data: (_) => _infoBlock(title: 'name'.tr(), value: clientName),
        ),
        SizedBox(height: AppSpacing.spaceLG),
        Text('proposal'.tr(),
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        SizedBox(height: AppSpacing.spaceSM),
        _infoBlock(title: 'label_status'.tr(), value: statusText),
        if (proposal.price != null)
          _infoBlock(
              title: 'label_price'.tr(), value: _fmtMoney(proposal.price)),
        if (proposal.durationDays != null)
          _infoBlock(
            title: 'label_duration'.tr(),
            value: '${proposal.durationDays} ${'days'.tr()}',
          ),
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
                  onPressed: actions.isLoading
                      ? null
                      : () async {
                          final ok = await vm.reject(proposal.id);
                          if (!context.mounted) return;
                          if (ok) {
                            AppSnackbar.show(context, 'operation_done'.tr());
                          }
                        },
                  child: Text('reject'.tr()),
                ),
              ),
              SizedBox(width: AppSpacing.spaceSM),
              Expanded(
                child: ElevatedButton(
                  onPressed: actions.isLoading
                      ? null
                      : () async {
                          final chatId = await vm.accept(proposal.id);
                          if (!context.mounted) return;

                          if (chatId != null && chatId.isNotEmpty) {
                            AppSnackbar.show(context, 'operation_done'.tr());
                            onOpenChat(context, chatId);
                          } else {
                            AppSnackbar.show(context, 'operation_done'.tr());
                          }
                        },
                  child: Text('accept'.tr()),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

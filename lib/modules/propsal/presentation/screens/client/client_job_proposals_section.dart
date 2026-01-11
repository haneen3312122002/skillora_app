import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_card.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_infinite_list.dart';

import 'package:notes_tasks/modules/profile/presentation/providers/profile/users_stream_provider.dart';

import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_status.dart';
import 'package:notes_tasks/modules/propsal/domain/failures/proposal_failure.dart';
import 'package:notes_tasks/modules/propsal/presentation/providers/proposals_stream_providers.dart';
import 'package:notes_tasks/modules/propsal/presentation/screens/proposal_details_page.dart';
import 'package:notes_tasks/modules/propsal/presentation/viewmodels/proposal_actions_viewmodel.dart';

class ClientJobProposalsSection extends ConsumerWidget {
  final String jobId;

  const ClientJobProposalsSection({
    super.key,
    required this.jobId,
  });

  void _openChat(BuildContext context, String chatId) {
    // ✅ adjust if your route differs
    context.push('/chat/$chatId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ listen for action errors once (safe to call in build with Riverpod)
    ref.listen(proposalActionsViewModelProvider, (prev, next) {
      next.when(
        data: (data) {
          
        },
        loading: () {
          
        },
        error: (e, _) {
          final key =
              (e is ProposalFailure) ? e.messageKey : 'something_went_wrong';
          AppSnackbar.show(context, key.tr());

          // clear sticky error
          ref.read(proposalActionsViewModelProvider.notifier).reset();
        },
      );
    });

    final async = ref.watch(jobProposalsStreamProvider(jobId));

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.spaceMD),
        child: Text(
          '${'error'.tr()}: $e',
          style: AppTextStyles.caption,
        ),
      ),
      data: (list) {
        if (list.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.spaceMD),
            child: Text(
              'no_proposals_yet'.tr(),
              style: AppTextStyles.caption,
            ),
          );
        }

        return AppInfiniteList<ProposalEntity>(
          items: list,
          hasMore: false,
          onLoadMore: () {},
          onRefresh: () async {
            ref.invalidate(jobProposalsStreamProvider(jobId));
          },
          padding: EdgeInsets.zero,
          animateItems: true,
          itemBuilder: (context, p, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.spaceSM),
              child: _ClientProposalCard(
                proposal: p,
                onOpen: () {
                  context.push(
                    AppRoutes.proposalDetails,
                    extra: ProposalDetailsArgs(
                      proposalId: p.id,
                      mode: PageMode.view,
                    ),
                  );
                },
                onOpenChat: _openChat,
              ),
            );
          },
        );
      },
    );
  }
}

class _ClientProposalCard extends ConsumerWidget {
  final ProposalEntity proposal;
  final VoidCallback onOpen;
  final void Function(BuildContext context, String chatId) onOpenChat;

  const _ClientProposalCard({
    required this.proposal,
    required this.onOpen,
    required this.onOpenChat,
  });

  String _fmtMoney(double? v) => v == null ? '-' : v.toStringAsFixed(0);

  String _statusKey(ProposalStatus s) {
    switch (s) {
      case ProposalStatus.pending:
        return 'proposal_status_pending';
      case ProposalStatus.accepted:
        return 'proposal_status_accepted';
      case ProposalStatus.rejected:
        return 'proposal_status_rejected';
    }
  }

  IconData _statusIcon(ProposalStatus s) {
    switch (s) {
      case ProposalStatus.pending:
        return Icons.hourglass_top;
      case ProposalStatus.accepted:
        return Icons.check_circle_outline;
      case ProposalStatus.rejected:
        return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(proposalActionsViewModelProvider.notifier);
    final canDecide = proposal.status == ProposalStatus.pending;
    final theme = Theme.of(context);

    final freelancerAsync =
        ref.watch(userByIdStreamProvider(proposal.freelancerId));

    final statusText = _statusKey(proposal.status).tr();

    return AppCard(
      padding: EdgeInsets.all(AppSpacing.spaceSM),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.r(16)),
        onTap: onOpen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            freelancerAsync.when(
              loading: () => _HeaderRow(
                name: 'loading_freelancer'.tr(),
                subtitle: '',
                photoUrl: null,
              ),
              error: (_, __) => _HeaderRow(
                name: 'freelancer_default_name'.tr(),
                subtitle: 'tap_to_view_proposal_details'.tr(),
                photoUrl: null,
              ),
              data: (u) {
                final name =
                    (u?['name'] ?? 'freelancer_default_name'.tr()).toString();
                final photoUrl = u?['photoUrl'] as String?;
                return _HeaderRow(
                  name: name,
                  subtitle: 'tap_to_view_proposal_details'.tr(),
                  photoUrl: photoUrl,
                );
              },
            ),
            SizedBox(height: AppSpacing.spaceSM),
            Row(
              children: [
                Expanded(
                  child: Text(
                    proposal.title,
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            SizedBox(height: AppSpacing.spaceXS),
            Text(
              proposal.coverLetter,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body,
            ),
            SizedBox(height: AppSpacing.spaceSM),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: _Badge(
                    icon: _statusIcon(proposal.status),
                    text: '${'label_status'.tr()}: $statusText',
                    borderColor: theme.dividerColor,
                  ),
                ),
                if (proposal.price != null) ...[
                  SizedBox(width: AppSpacing.spaceSM),
                  _Badge(
                    icon: Icons.payments_outlined,
                    text: '${'label_price'.tr()}: ${_fmtMoney(proposal.price)}',
                    borderColor: theme.dividerColor,
                  ),
                ],
              ],
            ),
            if (canDecide) ...[
              SizedBox(height: AppSpacing.spaceMD),
              Consumer(
                builder: (_, ref, __) {
                  final loading =
                      ref.watch(proposalActionsViewModelProvider).isLoading;

                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: loading
                              ? null
                              : () async {
                                  final ok = await vm.reject(proposal.id);
                                  if (!context.mounted) return;
                                  if (ok) {
                                    AppSnackbar.show(
                                      context,
                                      'operation_done'.tr(),
                                    );
                                  }
                                },
                          icon: const Icon(Icons.close),
                          label: Text('reject'.tr()),
                        ),
                      ),
                      SizedBox(width: AppSpacing.spaceSM),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: loading
                              ? null
                              : () async {
                                  final chatId = await vm.accept(proposal.id);
                                  if (!context.mounted) return;

                                  if (chatId != null && chatId.isNotEmpty) {
                                    AppSnackbar.show(
                                      context,
                                      'operation_done'.tr(),
                                    );
                                    onOpenChat(context, chatId);
                                  } else {
                                    // accept succeeded but chatId missing (rare) -> show generic
                                    AppSnackbar.show(
                                      context,
                                      'operation_done'.tr(),
                                    );
                                  }
                                },
                          icon: const Icon(Icons.check),
                          label: Text('accept'.tr()),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? photoUrl;

  const _HeaderRow({
    required this.name,
    required this.subtitle,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: photoUrl == null ? null : NetworkImage(photoUrl!),
          child: photoUrl == null
              ? const Icon(Icons.person_outline, size: 18)
              : null,
        ),
        SizedBox(width: AppSpacing.spaceSM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              ),
              if (subtitle.isNotEmpty) ...[
                SizedBox(height: AppSpacing.spaceXXS),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color borderColor;

  const _Badge({
    required this.icon,
    required this.text,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 30),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceSM,
        vertical: AppSpacing.spaceXS,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.r(999)),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          SizedBox(width: AppSpacing.spaceXS),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}

class ClientProposalsArgs {
  final String jobId;
  const ClientProposalsArgs({required this.jobId});
}

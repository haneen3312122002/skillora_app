import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routs/app_routes.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_card.dart';

import 'package:notes_tasks/core/shared/widgets/lists/app_infinite_list.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_list_tile.dart';

import 'package:notes_tasks/modules/profile/presentation/providers/profile/users_stream_provider.dart';
import 'package:notes_tasks/modules/propseles/presentation/viewmodels/proposal_actions_viewmodel.dart';
import 'package:notes_tasks/modules/propseles/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propseles/domain/entities/propsal_status.dart';
import 'package:notes_tasks/modules/propseles/presentation/providers/proposals_stream_providers.dart';
import 'package:notes_tasks/modules/propseles/presentation/screens/proposal_details_page.dart';

class ClientJobProposalsSection extends ConsumerWidget {
  final String jobId;

  const ClientJobProposalsSection({
    super.key,
    required this.jobId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(jobProposalsStreamProvider(jobId));

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
      data: (list) {
        if (list.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.spaceMD),
            child: Text('No proposals yet', style: AppTextStyles.caption),
          );
        }

        return AppInfiniteList<ProposalEntity>(
          items: list,
          hasMore: false,
          onLoadMore: () {},
          onRefresh: () async {
            ref.invalidate(jobProposalsStreamProvider(jobId));
          },
          padding: EdgeInsets.zero, // الصفحة أصلاً فيها Padding
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

  const _ClientProposalCard({
    required this.proposal,
    required this.onOpen,
  });

  String _fmtMoney(double? v) => v == null ? '-' : v.toStringAsFixed(0);

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

    final statusText = _fmtStatus(proposal.status);

    return AppCard(
      padding: EdgeInsets.all(AppSpacing.spaceSM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Header موحّد: AppListTile داخل الكارد
          freelancerAsync.when(
            loading: () => AppListTile(
              animate: false,
              leading: const CircleAvatar(radius: 18),
              title: 'Loading freelancer...',
              trailing: const SizedBox.shrink(),
              onTap: onOpen,
            ),
            error: (e, _) => Text('Freelancer error: $e'),
            data: (u) {
              final name = (u?['name'] ?? 'Freelancer') as String;
              final photoUrl = u?['photoUrl'] as String?;

              return AppListTile(
                animate: false,
                leading: CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      photoUrl == null ? null : NetworkImage(photoUrl),
                  child: photoUrl == null
                      ? const Icon(Icons.person_outline, size: 18)
                      : null,
                ),
                title: name,
                subtitle: 'Tap to view proposal details',
                trailing: const Icon(Icons.chevron_right),
                onTap: onOpen,
              );
            },
          ),

          SizedBox(height: AppSpacing.spaceSM),

          Text(
            proposal.title,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.spaceXS),
          Text(
            proposal.coverLetter,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body,
          ),

          SizedBox(height: AppSpacing.spaceSM),

          // ✅ Status + Price بدون overflow
          Row(
            children: [
              Icon(_statusIcon(proposal.status), size: 18),
              SizedBox(width: AppSpacing.spaceSM),
              Expanded(
                child: Text(
                  'Status: $statusText',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ),
              if (proposal.price != null) ...[
                SizedBox(width: AppSpacing.spaceSM),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.spaceSM,
                    vertical: AppSpacing.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.r(999)),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Text(
                    _fmtMoney(proposal.price),
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),

          // ✅ Buttons فقط لما تكون pending
          if (canDecide) ...[
            SizedBox(height: AppSpacing.spaceMD),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => vm.reject(context, proposal.id),
                    icon: const Icon(Icons.close),
                    label: const Text('Reject'),
                  ),
                ),
                SizedBox(width: AppSpacing.spaceSM),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => vm.accept(context, proposal.id),
                    icon: const Icon(Icons.check),
                    label: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class ClientProposalsArgs {
  final String jobId;
  const ClientProposalsArgs({required this.jobId});
}

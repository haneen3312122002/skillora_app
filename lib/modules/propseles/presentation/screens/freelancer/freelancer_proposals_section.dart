import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/app/routs/app_routes.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_card.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_tabs_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_infinite_list.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_list_tile.dart';
import 'package:notes_tasks/modules/propseles/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propseles/domain/entities/propsal_status.dart';
import 'package:notes_tasks/modules/propseles/presentation/providers/proposals_stream_providers.dart';
import 'package:notes_tasks/modules/propseles/presentation/screens/proposal_details_page.dart';

class FreelancerProposalsListPage extends ConsumerWidget {
  const FreelancerProposalsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myProposalsStreamProvider);

    return async.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (list) {
        // ✅ تقسيم حسب الحالة
        final pending =
            list.where((p) => p.status == ProposalStatus.pending).toList();
        final accepted =
            list.where((p) => p.status == ProposalStatus.accepted).toList();
        final rejected =
            list.where((p) => p.status == ProposalStatus.rejected).toList();

        return AppTabsScaffold(
          title: 'My Proposals',
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Accepted'),
            Tab(text: 'Rejected'),
          ],
          views: [
            _ProposalsByStatusList(items: pending),
            _ProposalsByStatusList(items: accepted),
            _ProposalsByStatusList(items: rejected),
          ],
        );
      },
    );
  }
}

class _FreelancerProposalCard extends ConsumerWidget {
  final ProposalEntity proposal;

  const _FreelancerProposalCard({required this.proposal});

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

  String _fmtMoney(double? v) => v == null ? '-' : v.toStringAsFixed(0);

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
    final theme = Theme.of(context);

    final jobTitle = proposal.jobTitle.isNotEmpty ? proposal.jobTitle : 'Job';
    final category =
        proposal.jobCategory.isNotEmpty ? proposal.jobCategory : '-';

    final statusText = _fmtStatus(proposal.status);

    return AppCard(
      // ✅ Padding خفيف للكارد فقط (بدون مبالغة)
      padding: EdgeInsets.all(AppSpacing.spaceSM),
      child: AppListTile(
        leading: Icon(_statusIcon(proposal.status)),
        title: jobTitle,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.push(
            AppRoutes.proposalDetails,
            extra: ProposalDetailsArgs(
              proposalId: proposal.id,
              mode: PageMode.view,
            ),
          );
        },

        // ✅ هنا حل الـ overflow + تصميم أحلى
        subtitleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // category + optional budget
            Row(
              children: [
                Expanded(
                  child: Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                ),
                if (proposal.jobBudget != null) ...[
                  SizedBox(width: AppSpacing.spaceSM),
                  Text(
                    'Budget: ${_fmtMoney(proposal.jobBudget)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                ],
              ],
            ),

            SizedBox(height: AppSpacing.spaceXS),

            Text(
              proposal.title,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: AppSpacing.spaceXS),

            Text(
              proposal.coverLetter,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body,
            ),

            SizedBox(height: AppSpacing.spaceSM),

            // ✅ سطر الحالة + Price badge (بدون overflow)
            Row(
              children: [
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//..................
class _ProposalsByStatusList extends ConsumerWidget {
  final List<ProposalEntity> items;

  const _ProposalsByStatusList({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.spaceLG),
          child: Text(
            'No proposals',
            style: AppTextStyles.caption,
          ),
        ),
      );
    }

    return AppInfiniteList<ProposalEntity>(
      items: items,
      hasMore: false,
      onLoadMore: () {},
      onRefresh: () async {},
      padding: EdgeInsets.zero,
      animateItems: true,
      itemBuilder: (context, p, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.spaceSM),
          child: _FreelancerProposalCard(proposal: p),
        );
      },
    );
  }
}

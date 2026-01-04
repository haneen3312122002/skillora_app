import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_card.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_tabs_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_infinite_list.dart';

import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_status.dart';
import 'package:notes_tasks/modules/propsal/presentation/providers/proposals_stream_providers.dart';
import 'package:notes_tasks/modules/propsal/presentation/screens/proposal_details_page.dart';

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
        body: Center(
          child: Text('${'error'.tr()}: $e', style: AppTextStyles.caption),
        ),
      ),
      data: (list) {
        final pending =
            list.where((p) => p.status == ProposalStatus.pending).toList();
        final accepted =
            list.where((p) => p.status == ProposalStatus.accepted).toList();
        final rejected =
            list.where((p) => p.status == ProposalStatus.rejected).toList();

        return AppTabsScaffold(
          title: 'my_proposals_title'.tr(),
          tabs: [
            Tab(text: 'proposal_status_pending'.tr()),
            Tab(text: 'proposal_status_accepted'.tr()),
            Tab(text: 'proposal_status_rejected'.tr()),
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
    final theme = Theme.of(context);

    final jobTitle =
        proposal.jobTitle.isNotEmpty ? proposal.jobTitle : 'job_fallback'.tr();
    final category =
        proposal.jobCategory.isNotEmpty ? proposal.jobCategory : 'dash'.tr();

    final statusText = _statusKey(proposal.status).tr();
    final budgetText = proposal.jobBudget == null
        ? null
        : '${'label_budget'.tr()}: ${_fmtMoney(proposal.jobBudget)}';

    return AppCard(
      padding: EdgeInsets.all(AppSpacing.spaceSM),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.r(16)),
        onTap: () {
          context.push(
            AppRoutes.proposalDetails,
            extra: ProposalDetailsArgs(
              proposalId: proposal.id,
              mode: PageMode.view,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================
            // Row 1: status icon + job title/category + optional budget
            // ======================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_statusIcon(proposal.status), size: 18),
                SizedBox(width: AppSpacing.spaceSM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: AppSpacing.spaceXXS),
                      Text(
                        category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                if (budgetText != null) ...[
                  SizedBox(width: AppSpacing.spaceSM),
                  Text(
                    budgetText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                ],
              ],
            ),

            SizedBox(height: AppSpacing.spaceSM),

            // ======================
            // Row 2: proposal title + chevron
            // ======================
            Row(
              children: [
                Expanded(
                  child: Text(
                    proposal.title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),

            SizedBox(height: AppSpacing.spaceXS),

            // ======================
            // Cover letter (خفيف)
            // ======================
            Text(
              proposal.coverLetter,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body,
              softWrap: true,
            ),

            SizedBox(height: AppSpacing.spaceSM),

            // ======================
            // Row 3: status badge + price badge
            // ======================
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: _Badge(
                    icon: Icons.info_outline,
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
          ],
        ),
      ),
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
            'no_proposals'.tr(),
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

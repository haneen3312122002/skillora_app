import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_card.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';
import 'package:notes_tasks/core/shared/widgets/common/empty_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_infinite_list.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_list_tile.dart';
import 'package:notes_tasks/modules/notifications/domain/failures/notifications_failure.dart';
import 'package:notes_tasks/modules/notifications/presentation/viewmodels/notifications_actions_viewmodel.dart';

import 'package:notes_tasks/modules/propsal/presentation/screens/proposal_details_page.dart';

import '../providers/notifications_stream_providers.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ UI side-effects only
    ref.listen(notificationsActionsViewModelProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) {
          final key = (e is NotificationsFailure)
              ? e.messageKey
              : 'something_went_wrong';
          AppSnackbar.show(context, key.tr());
        },
      );
    });

    final actionsAsync = ref.watch(notificationsActionsViewModelProvider);
    final actionsVm = ref.read(notificationsActionsViewModelProvider.notifier);

    final async = ref.watch(notificationsStreamProvider);

    return AppScaffold(
      scrollable: false,
      extendBodyBehindAppBar: false,
      useSafearea: true,
      title: 'notifications'.tr(),
      body: async.when(
        data: (items) {
          if (items.isEmpty) return const EmptyView();

          return AppInfiniteList(
            items: items,
            hasMore: false,
            onLoadMore: () {},
            onRefresh: () async => ref.invalidate(notificationsStreamProvider),
            padding: const EdgeInsets.all(12),
            animateItems: true,
            itemBuilder: (context, n, index) {
              final isBusy = actionsAsync.isLoading;

              return Padding(
                padding: EdgeInsets.all(AppSpacing.spaceXS),
                child: AppCard(
                  animate: true,
                  child: AppListTile(
                    title: n.title,
                    subtitle: n.body,
                    leading: Icon(
                      n.read
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                    ),
                    trailing:
                        n.read ? null : const Icon(Icons.circle, size: 10),
                    onTap: isBusy
                        ? null
                        : () {
                            // ✅ fire-and-forget, UI doesn't await
                            actionsVm.markAsRead(n.id);

                            if (n.type == 'proposal_status' &&
                                n.refId != null) {
                              context.push(
                                AppRoutes.proposalDetails,
                                extra: ProposalDetailsArgs(
                                  proposalId: n.refId!,
                                  mode: PageMode.view,
                                ),
                              );
                            }

                            // TODO: map other types (job_created/chat_message)
                          },
                  ),
                ),
              );
            },
          );
        },
        loading: () =>
            const Center(child: LoadingIndicator(withBackground: false)),
        error: (_, __) => ErrorView(
          message: 'something_went_wrong'.tr(),
          fullScreen: false,
          onRetry: () => ref.refresh(notificationsStreamProvider),
        ),
      ),
    );
  }
}

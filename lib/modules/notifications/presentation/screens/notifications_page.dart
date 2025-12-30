import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/app/routs/app_routes.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/widgets/cards/app_card.dart';

import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';
import 'package:notes_tasks/core/shared/widgets/common/empty_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_infinite_list.dart';
import 'package:notes_tasks/core/shared/widgets/lists/app_list_tile.dart';
import 'package:notes_tasks/modules/propseles/presentation/screens/proposal_details_page.dart';

import '../viewmodels/notifications_inbox_viewmodel.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificationsInboxViewModelProvider);

    return AppScaffold(
      scrollable: false, // ✅ مهم: عشان ما يصير Scroll داخل Scroll
      extendBodyBehindAppBar: false,
      useSafearea: true,
      title: 'notifications',
      body: async.when(
        data: (items) {
          if (items.isEmpty) return const EmptyView();

          // ✅ AppInfiniteList هو الـ scroll الوحيد في الصفحة
          return AppInfiniteList(
            items: items,
            hasMore: false, // حاليا ما عندنا pagination
            onLoadMore: () {}, // مطلوب بالويدجت
            onRefresh: () async {
              // refresh stream provider
              ref.invalidate(notificationsInboxViewModelProvider);
            },
            padding: const EdgeInsets.all(12),
            animateItems: true,
            itemBuilder: (context, n, index) {
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
                    onTap: () async {
                      await ref
                          .read(markNotificationReadControllerProvider)
                          .markAsRead(n.id);

                      if (n.type == 'proposal_status') {
                        context.push(
                          AppRoutes.proposalDetails,
                          extra: ProposalDetailsArgs(
                            proposalId: n.refId!, // ✅ مهم جداً
                            mode: PageMode.view,
                          ),
                        );
                        return;
                      }

                      if (n.type == 'job_created') {
                        // context.push('${AppRoutes.jobDetails}/${n.refId}');
                        return;
                      }

                      if (n.type == 'chat_message') {
                        // context.push('${AppRoutes.chatDetails}/${n.refId}');
                        return;
                      }

                      if (n.type == 'job_created') {
                        // مثال لو عندك job details route
                        // context.push('${AppRoutes.jobDetails}/${n.refId}');
                        return;
                      }

                      if (n.type == 'chat_message') {
                        // مثال: refId = chatId (حسب كيف خزنتيها)
                        // context.push('${AppRoutes.chatDetails}/${n.refId}');
                        return;
                      }
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
          onRetry: () => ref.refresh(notificationsInboxViewModelProvider),
        ),
      ),
    );
  }
}

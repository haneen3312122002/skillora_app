import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/constants/spacing.dart';
import 'package:notes_tasks/core/widgets/empty_view.dart';
import 'package:notes_tasks/core/widgets/error_view.dart';
import 'package:notes_tasks/core/widgets/loading_indicator.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/get_profile_stream.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/profile_actions_card.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/profile_header.dart';

class ProfileContent extends ConsumerWidget {
  const ProfileContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileStreamProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const EmptyView(message: 'No profile data found');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeader(profile: profile),
            SizedBox(height: AppSpacing.spaceLG),
            ProfileActionsCard(profile: profile),
          ],
        );
      },
      loading: () => const LoadingIndicator(withBackground: false),
      error: (e, st) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.refresh(profileStreamProvider)),
    );
  }
}

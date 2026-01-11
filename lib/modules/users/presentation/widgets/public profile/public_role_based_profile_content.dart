import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/common/empty_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';

import 'package:notes_tasks/modules/users/presentation/providers/public_profile/public_profile_providers.dart';
import 'package:notes_tasks/modules/users/presentation/widgets/public%20profile/public_bio_section_container.dart';
import 'package:notes_tasks/modules/users/presentation/widgets/public%20profile/public_profile_header.dart';
import 'package:notes_tasks/modules/users/presentation/widgets/public%20profile/role_sections/public_role_sections.dart';

// ✅ Read-only versions (رح نعملهم تحت)

class PublicRoleBasedProfileContent extends ConsumerWidget {
  final String uid;

  const PublicRoleBasedProfileContent({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(publicProfileStreamProvider(uid));

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return EmptyView(message: 'no_profile_data'.tr());
        }

        return Padding(
          padding: EdgeInsets.all(AppSpacing.spaceMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PublicProfileHeader(profile: profile), // ✅ بدون تعديل صور
              SizedBox(height: AppSpacing.spaceLG),

              PublicBioSectionContainer(profile: profile), // ✅ عرض فقط
              SizedBox(height: AppSpacing.spaceLG),

              PublicRoleSections(
                  uid: uid, profile: profile), // ✅ أقسام حسب role
              SizedBox(height: AppSpacing.spaceLG),
            ],
          ),
        );
      },
      loading: () => const LoadingIndicator(withBackground: false),
      error: (e, st) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.refresh(publicProfileStreamProvider(uid)),
      ),
    );
  }
}

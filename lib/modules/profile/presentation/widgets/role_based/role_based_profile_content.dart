import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';
import 'package:notes_tasks/core/shared/widgets/common/empty_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/get_profile_stream_provider.dart';

import 'package:notes_tasks/modules/profile/presentation/widgets/header/profile_header.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/bio/bio_section_container.dart';

import 'package:notes_tasks/modules/profile/presentation/widgets/role_based/admin/admin_profile_sections.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/role_based/client/client_profile_sections.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/role_based/freelancer/freelancer_profile_sections.dart';

class RoleBasedProfileContent extends ConsumerWidget {
  const RoleBasedProfileContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileStreamProvider);

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
              ProfileHeader(profile: profile),
              SizedBox(height: AppSpacing.spaceLG),
              const BioSectionContainer(),
              SizedBox(height: AppSpacing.spaceLG),
              _RoleSections(profile: profile),
              SizedBox(height: AppSpacing.spaceLG),
            ],
          ),
        );
      },
      loading: () => const LoadingIndicator(withBackground: false),
      error: (e, st) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.refresh(profileStreamProvider),
      ),
    );
  }
}

class _RoleSections extends StatelessWidget {
  final dynamic profile; // ProfileEntity

  const _RoleSections({required this.profile});

  @override
  Widget build(BuildContext context) {
    final role = profile.role as UserRole;

    switch (role) {
      case UserRole.client:
        return ClientProfileSections(profile: profile);
      case UserRole.admin:
        return AdminProfileSections(profile: profile);
      case UserRole.freelancer:
      default:
        return FreelancerProfileSections(profile: profile);
    }
  }
}

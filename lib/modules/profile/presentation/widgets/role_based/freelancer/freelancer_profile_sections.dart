import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';

import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/get_profile_stream_provider.dart';

import 'package:notes_tasks/modules/profile_experience/presentation/widgets/experiences_section_container.dart';

import 'package:notes_tasks/modules/profile_skills/presentation/widgets/skill_section_container.dart';

import 'package:notes_tasks/modules/profile_projects/presentation/providers/projects_stream_provider.dart';
import 'package:notes_tasks/modules/profile_projects/presentation/widgets/profile_projects_section.dart';

class FreelancerProfileSections extends ConsumerWidget {
  final ProfileEntity profile;

  const FreelancerProfileSections({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(effectiveProfileUidProvider);
    final canEdit = ref.watch(canEditProfileProvider);

    if (uid == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text('no_profile_data'.tr()),
      );
    }

    // ✅ projects family
    final projectsAsync = ref.watch(projectsStreamProvider(uid));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // =====================
        // Experiences (Container already handles uid + canEdit)
        // =====================
        const ExperiencesSectionContainer(),

        SizedBox(height: AppSpacing.spaceLG),

        // =====================
        // Skills (Container handles edit logic)
        // =====================
        const SkillsSectionContainer(),

        SizedBox(height: AppSpacing.spaceLG),

        // =====================
        // Projects (STREAM)
        // =====================
        projectsAsync.when(
          data: (projects) => ProfileProjectsSection(
            projects: projects,
            canEdit: canEdit, // ✅ لازم نضيفها على ProfileProjectsSection
          ),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, st) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'failed_load_projects'.tr(),
              style: AppTextStyles.caption.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

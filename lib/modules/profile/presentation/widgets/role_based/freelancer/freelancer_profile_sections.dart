import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/app/theme/text_styles.dart';

import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';
import 'package:notes_tasks/modules/profile_projects/presentation/providers/projects_stream_provider.dart';
import 'package:notes_tasks/modules/profile_experience/presentation/widgets/experiences_section_container.dart';

import 'package:notes_tasks/modules/profile_projects/presentation/widgets/profile_projects_section.dart';
import 'package:notes_tasks/modules/profile_skills/presentation/widgets/skill_section_container.dart';

class FreelancerProfileSections extends ConsumerWidget {
  final ProfileEntity profile;

  const FreelancerProfileSections({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ExperiencesSectionContainer(),
        SizedBox(height: AppSpacing.spaceLG),
        const SkillsSectionContainer(),
        SizedBox(height: AppSpacing.spaceLG),
        projectsAsync.when(
          data: (projects) => ProfileProjectsSection(projects: projects),
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e, st) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'failed_load_projects'.tr(), // تأكد تضيف المفتاح في اللغات
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

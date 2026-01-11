import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';

import 'package:notes_tasks/modules/profile_experience/presentation/providers/experiences_stream_provider.dart';
import 'package:notes_tasks/modules/profile_experience/presentation/widgets/profile_experience_section.dart';

import 'package:notes_tasks/modules/profile_projects/presentation/providers/projects_stream_provider.dart';
import 'package:notes_tasks/modules/profile_projects/presentation/widgets/profile_projects_section.dart';
import 'package:notes_tasks/modules/users/presentation/widgets/public%20profile/skills/public_skills_section_container.dart';

class PublicFreelancerSections extends ConsumerWidget {
  final String uid;
  final ProfileEntity profile;

  const PublicFreelancerSections({
    super.key,
    required this.uid,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiencesAsync = ref.watch(experiencesStreamProvider(uid));
    final projectsAsync = ref.watch(projectsStreamProvider(uid));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        experiencesAsync.when(
          data: (exps) => ProfileExperienceSection(
            experiences: exps,
            onAddExperience: null,
            onEditExperience: null,
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text('EXP ERROR: $e'),
          ),
        ),

        SizedBox(height: AppSpacing.spaceLG),

        // ✅ Skills public (لا edit)
        PublicSkillsSectionContainer(profile: profile),

        SizedBox(height: AppSpacing.spaceLG),

        projectsAsync.when(
          data: (projects) => ProfileProjectsSection(
            projects: projects,
            canEdit: false, // ✅ read-only
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text('PROJ ERROR: $e'),
          ),
        ),
      ],
    );
  }
}

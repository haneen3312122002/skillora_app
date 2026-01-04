import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/modules/job/presentation/screens/profile_jobs_section.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';

import 'package:notes_tasks/modules/job/presentation/providers/jobs_stream_providers.dart';

import 'package:notes_tasks/modules/profile_experience/presentation/providers/experiences_stream_provider.dart';
import 'package:notes_tasks/modules/profile_experience/presentation/widgets/profile_experience_section.dart';
import 'package:notes_tasks/modules/profile_experience/presentation/widgets/experience_form_widget.dart';

class ClientProfileSections extends ConsumerWidget {
  final ProfileEntity profile;

  const ClientProfileSections({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myJobsAsync = ref.watch(myJobsStreamProvider);
    final experiencesAsync = ref.watch(experiencesStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // =====================
        // Jobs Section (STREAM)
        // =====================
        myJobsAsync.when(
          data: (jobs) => ProfileJobsSection(jobs: jobs),
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('JOBS ERROR: $e'),
          ),
        ),

        SizedBox(height: AppSpacing.spaceXL),

        // =====================
        // Experiences Section
        // =====================
        experiencesAsync.when(
          data: (exps) => ProfileExperienceSection(
            experiences: exps,
            onAddExperience: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const ExperienceFormWidget(),
              );
            },
            onEditExperience: (exp) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => ExperienceFormWidget(initial: exp),
              );
            },
          ),
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('EXP ERROR: $e'),
          ),
        ),
      ],
    );
  }
}

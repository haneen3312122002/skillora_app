import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';

import 'package:notes_tasks/modules/job/presentation/providers/jobs_stream_providers.dart';
import 'package:notes_tasks/modules/job/presentation/screens/profile_jobs_section.dart';

import 'package:notes_tasks/modules/profile_experience/presentation/providers/experiences_stream_provider.dart';
import 'package:notes_tasks/modules/profile_experience/presentation/widgets/profile_experience_section.dart';

class PublicClientSections extends ConsumerWidget {
  final String uid;
  final ProfileEntity profile;

  const PublicClientSections({
    super.key,
    required this.uid,
    required this.profile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myJobsAsync = ref.watch(myJobsStreamProvider(uid));
    final experiencesAsync = ref.watch(experiencesStreamProvider(uid));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        myJobsAsync.when(
          data: (jobs) => ProfileJobsSection(
            jobs: jobs,
            isPublic: true,
          ),
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
        experiencesAsync.when(
          data: (exps) => ProfileExperienceSection(
            experiences: exps,
            onAddExperience: null, // ✅ read-only
            onEditExperience: null, // ✅ read-only
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

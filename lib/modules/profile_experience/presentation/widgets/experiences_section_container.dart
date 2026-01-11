import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';
import 'package:notes_tasks/core/shared/widgets/pages/app_bottom_sheet.dart';

import 'package:notes_tasks/modules/profile/presentation/providers/profile/get_profile_stream_provider.dart';

import 'package:notes_tasks/modules/profile_experience/domain/entities/experience_entity.dart';
import 'package:notes_tasks/modules/profile_experience/presentation/providers/experiences_stream_provider.dart';
import 'package:notes_tasks/modules/profile_experience/presentation/widgets/experience_form_widget.dart';
import 'package:notes_tasks/modules/profile_experience/presentation/widgets/profile_experience_section.dart';

class ExperiencesSectionContainer extends ConsumerWidget {
  const ExperiencesSectionContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(effectiveProfileUidProvider);
    final canEdit = ref.watch(canEditProfileProvider);

    if (uid == null) {
      return Padding(
        padding: EdgeInsets.all(AppSpacing.spaceMD),
        child: Text('no_profile_data'.tr()),
      );
    }

    final experiencesAsync = ref.watch(experiencesStreamProvider(uid));

    return experiencesAsync.when(
      data: (experiences) {
        return ProfileExperienceSection(
          experiences: experiences,
          onAddExperience: canEdit
              ? () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const AppBottomSheet(
                      child: ExperienceFormWidget(),
                    ),
                  );
                }
              : null,
          onEditExperience: canEdit
              ? (ExperienceEntity exp) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => AppBottomSheet(
                      child: ExperienceFormWidget(initial: exp),
                    ),
                  );
                }
              : null,
        );
      },
      loading: () => Padding(
        padding: EdgeInsets.all(AppSpacing.spaceMD),
        child: const LoadingIndicator(),
      ),
      error: (e, st) => Padding(
        padding: EdgeInsets.all(AppSpacing.spaceMD),
        child: ErrorView(
          message: 'failed_load_experiences'.tr(),
          onRetry: () => ref.refresh(experiencesStreamProvider(uid)), // ✅ مهم
        ),
      ),
    );
  }
}

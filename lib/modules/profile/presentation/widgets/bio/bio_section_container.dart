import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/bio/bio_editing.dart';

import 'package:notes_tasks/modules/profile/presentation/providers/bio/bio_provider.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/bio/bio_form_viewmodel.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/bio/bio_section.dart';

class BioSectionContainer extends ConsumerWidget {
  const BioSectionContainer({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = ref.watch(bioEditingProvider);
    final bio = ref.watch(bioProvider);

    ref.listen(bioFormViewModelProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) => AppSnackbar.show(context, 'failed_with_error'.tr()),
        data: (_) {
          final wasLoading = prev?.isLoading ?? false;
          if (wasLoading) {
            AppSnackbar.show(context, 'bio_updated_success'.tr());
            ref.read(bioEditingProvider.notifier).state = false;
          }
        },
      );
    });

    final vm = ref.read(bioFormViewModelProvider.notifier);
    final async = ref.watch(bioFormViewModelProvider);

    return BioSection(
      titleKey: 'profile_bio',
      bio: bio,
      emptyHintKey: 'bio_empty_hint',
      isEditing: isEditing,
      isSaving: async.isLoading,
      onEdit: () {
        vm.init(bio);
        ref.read(bioEditingProvider.notifier).state = true;
      },
      onCancel: () {
        ref.read(bioEditingProvider.notifier).state = false;
        vm.init(bio);
      },
      onChanged: vm.onChanged,
      onSave: () async {
        await vm.saveBio(); // ✅ no context
      },
    );
  }
}

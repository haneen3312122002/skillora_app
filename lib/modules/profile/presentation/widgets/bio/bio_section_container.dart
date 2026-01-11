import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/bio/bio_editing.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/bio/bio_provider.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/get_profile_stream_provider.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/bio/bio_form_viewmodel.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/bio/bio_section.dart';
// ... باقي imports

class BioSectionContainer extends ConsumerWidget {
  const BioSectionContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEdit = ref.watch(canEditProfileProvider);

    final isEditing = ref.watch(bioEditingProvider);
    final bio = ref.watch(bioProvider);

    // ... listen كما هو

    final vm = ref.read(bioFormViewModelProvider.notifier);
    final async = ref.watch(bioFormViewModelProvider);

    return BioSection(
      canEdit: canEdit,
      titleKey: 'profile_bio',
      bio: bio,
      emptyHintKey: 'bio_empty_hint',

      isEditing: canEdit ? isEditing : false, // ✅ الزائر ما يدخل edit
      isSaving: async.isLoading,

      onEdit: canEdit
          ? () {
              vm.init(bio);
              ref.read(bioEditingProvider.notifier).state = true;
            }
          : () {},

      onCancel: () {
        ref.read(bioEditingProvider.notifier).state = false;
        vm.init(bio);
      },

      onChanged: vm.onChanged,

      onSave: () async {
        if (!canEdit) return;
        await vm.saveBio();
      },
    );
  }
}

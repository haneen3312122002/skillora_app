import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/get_profile_stream_provider.dart';

import 'package:notes_tasks/modules/profile_skills/presentation/providers/skills_provider.dart';
import 'package:notes_tasks/modules/profile_skills/presentation/viewmodels/skills_form_viewmodel.dart';
import 'package:notes_tasks/modules/profile_skills/presentation/widgets/profile_skill_section.dart';

class SkillsSectionContainer extends ConsumerWidget {
  const SkillsSectionContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(effectiveProfileUidProvider);
    final canEdit = ref.watch(canEditProfileProvider);

    if (uid == null) {
      return const SizedBox.shrink();
    }

    final profileSkills = ref.watch(skillsProvider(uid)); // ✅ صار uid-based

    final async = ref.watch(skillsFormViewModelProvider);
    final vm = ref.read(skillsFormViewModelProvider.notifier);

    final s = async.value ?? const SkillsFormState();

    // ✅ الزائر ممنوع editing حتى لو state حكى غير هيك
    final isEditing = canEdit ? s.isEditing : false;
    final displayed = isEditing ? s.skills : profileSkills;

    return ProfileSkillsSection(
      skills: displayed,
      canEdit: canEdit, // ✅ جديد
      isEditing: isEditing,
      isSaving: async.isLoading,

      onEdit: canEdit ? () => vm.startEditing(profileSkills) : () {},
      onCancel: canEdit ? vm.cancelEditing : () {},
      onSave: canEdit ? () => vm.saveSkills(context) : () async {},

      onAddSkill: canEdit ? vm.addSkill : (_) {},
      onRemoveSkillAt: canEdit ? vm.removeSkillAt : (_) {},
    );
  }
}

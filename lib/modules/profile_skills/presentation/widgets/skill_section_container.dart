import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/modules/profile_skills/presentation/providers/skills_provider.dart';
import 'package:notes_tasks/modules/profile_skills/presentation/viewmodels/skills_form_viewmodel.dart';
import 'package:notes_tasks/modules/profile_skills/presentation/widgets/profile_skill_section.dart';

class SkillsSectionContainer extends ConsumerWidget {
  const SkillsSectionContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileSkills = ref.watch(skillsProvider);

    final async = ref.watch(skillsFormViewModelProvider);
    final vm = ref.read(skillsFormViewModelProvider.notifier);

    final s = async.value ?? const SkillsFormState();

    final displayed = s.isEditing ? s.skills : profileSkills;

    return ProfileSkillsSection(
      skills: displayed,
      isEditing: s.isEditing,
      isSaving: async.isLoading,
      onEdit: () => vm.startEditing(profileSkills),
      onCancel: vm.cancelEditing,
      onSave: () => vm.saveSkills(context),
      onAddSkill: vm.addSkill,
      onRemoveSkillAt: vm.removeSkillAt,
    );
  }
}

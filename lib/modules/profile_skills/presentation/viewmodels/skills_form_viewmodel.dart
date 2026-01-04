import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/modules/profile_skills/domain/usecases/set_skills_usecase.dart';

class SkillsFormState {
  final List<String> skills;
  final bool isEditing;

  const SkillsFormState({
    this.skills = const [],
    this.isEditing = false,
  });

  SkillsFormState copyWith({
    List<String>? skills,
    bool? isEditing,
  }) {
    return SkillsFormState(
      skills: skills ?? this.skills,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

final skillsFormViewModelProvider =
    AsyncNotifierProvider<SkillsFormViewModel, SkillsFormState>(
  SkillsFormViewModel.new,
);

class SkillsFormViewModel extends AsyncNotifier<SkillsFormState> {
  late final SetSkillsUseCase _setSkills = ref.read(setSkillsUseCaseProvider);

  @override
  FutureOr<SkillsFormState> build() => const SkillsFormState();

  List<String> _clean(List<String> items) {
    final set = <String>{};
    for (final s in items) {
      final v = s.trim();
      if (v.isNotEmpty) set.add(v);
    }
    return set.toList();
  }

  void startEditing(List<String> initialSkills) {
    state = AsyncData(
      state.value!.copyWith(
        skills: _clean(initialSkills),
        isEditing: true,
      ),
    );
  }

  void cancelEditing() {
    state = AsyncData(state.value!.copyWith(isEditing: false));
  }

  void addSkill(String skill) {
    final current = state.value!;
    final updated = _clean([...current.skills, skill]);
    state = AsyncData(current.copyWith(skills: updated));
  }

  void removeSkillAt(int index) {
    final current = state.value!;
    if (index < 0 || index >= current.skills.length) return;

    final updated = [...current.skills]..removeAt(index);
    state = AsyncData(current.copyWith(skills: updated));
  }

  Future<void> saveSkills(BuildContext context) async {
    if (state.isLoading) return;

    final current = state.value!;
    final cleaned = _clean(current.skills);

    state = const AsyncLoading();
    try {
      await _setSkills(cleaned);

      state = AsyncData(
        current.copyWith(
          skills: cleaned,
          isEditing: false,
        ),
      );

      if (!context.mounted) return;
      AppSnackbar.show(context, 'skills_updated_success'.tr());
    } catch (e, st) {
      state = AsyncError(e, st);

      if (!context.mounted) return;
      AppSnackbar.show(
        context,
        'failed_with_error'.tr(namedArgs: {'error': e.toString()}),
      );
    }
  }
}

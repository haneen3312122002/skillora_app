import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';
import 'package:notes_tasks/modules/job/presentation/providers/job_usecases_providers.dart';

final jobFormViewModelProvider =
    AsyncNotifierProvider<JobFormViewModel, JobFormState?>(
  JobFormViewModel.new,
);

class JobFormState {
  final String? id;
  final String title;
  final String description;
  final List<String> skills;
  final String imageUrl;
  final String jobUrl;
  final double? budget;
  final DateTime? deadline;

  // ✅ NEW
  final String category;

  const JobFormState({
    this.id,
    this.title = '',
    this.description = '',
    this.skills = const [],
    this.imageUrl = '',
    this.jobUrl = '',
    this.budget,
    this.deadline,
    this.category = '',
  });

  bool get isEdit => id != null;

  JobFormState copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? skills,
    String? imageUrl,
    String? jobUrl,
    double? budget,
    DateTime? deadline,
    String? category, // ✅ optional
  }) {
    return JobFormState(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      skills: skills ?? this.skills,
      imageUrl: imageUrl ?? this.imageUrl,
      jobUrl: jobUrl ?? this.jobUrl,
      budget: budget ?? this.budget,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
    );
  }
}

class JobFormViewModel extends AsyncNotifier<JobFormState?> {
  late final _add = ref.read(addJobUseCaseProvider);
  late final _update = ref.read(updateJobUseCaseProvider);

  @override
  FutureOr<JobFormState?> build() async => null;

  void initForCreate() => state = const AsyncData(JobFormState());

  void initForEdit(JobEntity job) {
    state = AsyncData(
      JobFormState(
        id: job.id,
        title: job.title,
        description: job.description,
        skills: job.skills,
        imageUrl: job.imageUrl ?? '',
        jobUrl: job.jobUrl ?? '',
        budget: job.budget,
        deadline: job.deadline,
        category: job.category, // ✅
      ),
    );
  }

  void setTitle(String v) => _set((s) => s.copyWith(title: v));
  void setDescription(String v) => _set((s) => s.copyWith(description: v));
  void setImageUrl(String v) => _set((s) => s.copyWith(imageUrl: v));
  void setJobUrl(String v) => _set((s) => s.copyWith(jobUrl: v));
  void setBudget(double? v) => _set((s) => s.copyWith(budget: v));
  void setDeadline(DateTime? v) => _set((s) => s.copyWith(deadline: v));

  // ✅ NEW
  void setCategory(String v) => _set((s) => s.copyWith(category: v));

  void _set(JobFormState Function(JobFormState s) fn) {
    final cur = state.value;
    if (cur == null) return;
    state = AsyncData(fn(cur));
  }

  void addSkill(String skill) {
    final cur = state.value;
    if (cur == null) return;
    final t = skill.trim();
    if (t.isEmpty || cur.skills.contains(t)) return;
    state = AsyncData(cur.copyWith(skills: [...cur.skills, t]));
  }

  void removeSkillAt(int index) {
    final cur = state.value;
    if (cur == null) return;
    if (index < 0 || index >= cur.skills.length) return;
    final list = [...cur.skills]..removeAt(index);
    state = AsyncData(cur.copyWith(skills: list));
  }

  String? _sanitizeUrl(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return null;
    if (!v.startsWith('http://') && !v.startsWith('https://')) return null;
    return v;
  }

  // ... نفس الكلاس تبعك، بس عدّلي submit:

  Future<String?> submit() async {
    final cur = state.value;
    if (cur == null || state.isLoading) return 'something_went_wrong';

    if (cur.title.trim().isEmpty || cur.description.trim().isEmpty) {
      return 'required';
    }
    if (cur.category.trim().isEmpty) {
      return 'required';
    }

    final imageUrl = _sanitizeUrl(cur.imageUrl);
    final jobUrl = _sanitizeUrl(cur.jobUrl);

    state = const AsyncLoading();

    try {
      if (cur.isEdit && cur.id != null) {
        await _update(
          id: cur.id!,
          title: cur.title.trim(),
          description: cur.description.trim(),
          skills: cur.skills,
          imageUrl: imageUrl,
          jobUrl: jobUrl,
          budget: cur.budget,
          deadline: cur.deadline,
          isOpen: true,
          category: cur.category.trim(),
        );
      } else {
        await _add(
          title: cur.title.trim(),
          description: cur.description.trim(),
          skills: cur.skills,
          imageUrl: imageUrl,
          jobUrl: jobUrl,
          budget: cur.budget,
          deadline: cur.deadline,
          category: cur.category.trim(),
        );
      }

      state = const AsyncData(null);
      return null; // ✅ success
    } catch (e, st) {
      state = AsyncError(e, st);
      return 'failed_with_error';
    }
  }
}

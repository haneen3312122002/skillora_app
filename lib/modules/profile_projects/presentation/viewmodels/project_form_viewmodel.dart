import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/modules/profile_projects/domain/entities/project_entity.dart';
import 'package:notes_tasks/modules/profile_projects/domain/usecases/add_project_usecase.dart';
import 'package:notes_tasks/modules/profile_projects/domain/usecases/update_project_usecase.dart';

final projectFormViewModelProvider =
    AsyncNotifierProvider<ProjectFormViewModel, ProjectFormState?>(
  ProjectFormViewModel.new,
);

class ProjectFormState {
  final String? id;
  final String title;
  final String description;
  final List<String> tools;
  final String imageUrl;
  final String projectUrl;

  const ProjectFormState({
    this.id,
    this.title = '',
    this.description = '',
    this.tools = const [],
    this.imageUrl = '',
    this.projectUrl = '',
  });

  bool get isEdit => id != null;

  ProjectFormState copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? tools,
    String? imageUrl,
    String? projectUrl,
  }) {
    return ProjectFormState(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      tools: tools ?? this.tools,
      imageUrl: imageUrl ?? this.imageUrl,
      projectUrl: projectUrl ?? this.projectUrl,
    );
  }
}

class ProjectFormViewModel extends AsyncNotifier<ProjectFormState?> {
  late final AddProjectUseCase _addUseCase =
      ref.read(addProjectUseCaseProvider);
  late final UpdateProjectUseCase _updateUseCase =
      ref.read(updateProjectUseCaseProvider);

  @override
  FutureOr<ProjectFormState?> build() async {
    return null; // يبدأ بدون state، نعمل init لما نفتح الفورم
  }

  void initForCreate() {
    state = const AsyncData(ProjectFormState());
  }

  void initForEdit(ProjectEntity project) {
    state = AsyncData(
      ProjectFormState(
        id: project.id,
        title: project.title,
        description: project.description,
        tools: project.tools,
        imageUrl: project.imageUrl ?? '',
        projectUrl: project.projectUrl ?? '',
      ),
    );
  }

  void updateFields({
    String? title,
    String? description,
    String? imageUrl,
    String? projectUrl,
  }) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        title: title ?? current.title,
        description: description ?? current.description,
        imageUrl: imageUrl ?? current.imageUrl,
        projectUrl: projectUrl ?? current.projectUrl,
      ),
    );
  }

  void addTool(String tool) {
    final current = state.value;
    if (current == null) return;

    final trimmed = tool.trim();
    if (trimmed.isEmpty) return;

    if (current.tools.contains(trimmed)) return;

    final updatedTools = [...current.tools, trimmed];
    state = AsyncData(current.copyWith(tools: updatedTools));
  }

  void removeToolAt(int index) {
    final current = state.value;
    if (current == null) return;

    if (index < 0 || index >= current.tools.length) return;

    final updatedTools = [...current.tools]..removeAt(index);
    state = AsyncData(current.copyWith(tools: updatedTools));
  }

  String? _sanitizeUrl(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return null;

    if (!v.startsWith('http://') && !v.startsWith('https://')) {
      return null;
    }
    return v;
  }

  Future<bool> submit(BuildContext context) async {
    final current = state.value;
    if (current == null) return false;
    if (state.isLoading) return false;

    if (current.title.trim().isEmpty) {
      AppSnackbar.show(context, 'project_title_required'.tr());
      return false;
    }

    if (current.description.trim().isEmpty) {
      AppSnackbar.show(context, 'project_description_required'.tr());
      return false;
    }

    final sanitizedImageUrl = _sanitizeUrl(current.imageUrl);
    final sanitizedProjectUrl = _sanitizeUrl(current.projectUrl);

    state = const AsyncLoading();

    try {
      if (current.isEdit && current.id != null) {
        await _updateUseCase(
          id: current.id!,
          title: current.title.trim(),
          description: current.description.trim(),
          tools: current.tools,
          imageUrl: sanitizedImageUrl,
          projectUrl: sanitizedProjectUrl,
        );
      } else {
        await _addUseCase(
          title: current.title.trim(),
          description: current.description.trim(),
          tools: current.tools,
          imageUrl: sanitizedImageUrl,
          projectUrl: sanitizedProjectUrl,
        );
      }

      AppSnackbar.show(
        context,
        current.isEdit
            ? 'project_updated_success'.tr()
            : 'project_added_success'.tr(),
      );

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      AppSnackbar.show(
        context,
        'failed_with_error'.tr(namedArgs: {'error': e.toString()}),
      );
      return false;
    }
  }
}

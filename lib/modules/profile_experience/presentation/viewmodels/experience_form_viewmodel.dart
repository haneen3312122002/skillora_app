import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';

import 'package:notes_tasks/modules/profile_experience/domain/usecases/add_experience_usecase.dart';
import 'package:notes_tasks/modules/profile_experience/domain/usecases/update_experience_usecase.dart';
import 'package:notes_tasks/modules/profile_experience/domain/usecases/delete_experience_usecase.dart';

final experienceFormViewModelProvider =
    AsyncNotifierProvider<ExperienceFormViewModel, void>(
  ExperienceFormViewModel.new,
);

class ExperienceFormViewModel extends AsyncNotifier<void> {
  late final _add = ref.read(addExperienceUseCaseProvider);
  late final _update = ref.read(updateExperienceUseCaseProvider);
  late final _delete = ref.read(deleteExperienceUseCaseProvider);

  @override
  FutureOr<void> build() {}

  bool _missingRequired(String title, String company) {
    return title.trim().isEmpty || company.trim().isEmpty;
  }

  Future<void> _run(
    BuildContext context,
    Future<void> Function() action, {
    required String successKey,
  }) async {
    if (state.isLoading) return;

    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      AppSnackbar.show(context, successKey.tr());
    } catch (e, st) {
      state = AsyncError(e, st);
      AppSnackbar.show(
        context,
        'failed_with_error'.tr(namedArgs: {'error': e.toString()}),
      );
    }
  }

  Future<void> addExperience(
    BuildContext context, {
    required String title,
    required String company,
    DateTime? startDate,
    DateTime? endDate,
    required String location,
    required String description,
  }) async {
    if (_missingRequired(title, company)) {
      AppSnackbar.show(context, 'experience_form_missing_fields'.tr());
      return;
    }

    return _run(
      context,
      () => _add(
        title: title.trim(),
        company: company.trim(),
        startDate: startDate,
        endDate: endDate,
        location: location.trim(),
        description: description.trim(),
      ).then((_) {}),
      successKey: 'experience_added_success',
    );
  }

  Future<void> updateExperience(
    BuildContext context, {
    required String id,
    required String title,
    required String company,
    DateTime? startDate,
    DateTime? endDate,
    required String location,
    required String description,
  }) async {
    if (_missingRequired(title, company)) {
      AppSnackbar.show(context, 'experience_form_missing_fields'.tr());
      return;
    }

    return _run(
      context,
      () => _update(
        id: id,
        title: title.trim(),
        company: company.trim(),
        startDate: startDate,
        endDate: endDate,
        location: location.trim(),
        description: description.trim(),
      ),
      successKey: 'experience_updated_success',
    );
  }

  Future<void> deleteExperience(
    BuildContext context, {
    required String id,
  }) async {
    return _run(
      context,
      () => _delete(id),
      successKey: 'experience_deleted_success',
    );
  }
}

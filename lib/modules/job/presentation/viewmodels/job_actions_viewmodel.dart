import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';
import 'package:notes_tasks/modules/job/domain/failures/job_failure.dart';
import 'package:notes_tasks/modules/job/presentation/providers/job_usecases_providers.dart';

final jobActionsViewModelProvider =
    AsyncNotifierProvider<JobActionsViewModel, void>(JobActionsViewModel.new);

class JobActionsViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> deleteJob(String jobId) async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    try {
      await ref.read(deleteJobUseCaseProvider)(jobId);
      state = const AsyncData(null);
    } on JobFailure catch (e, st) {
      state = AsyncError(e, st);
    } catch (e, st) {
      state = AsyncError(const JobFailure('job_delete_failed'), st);
    }
  }

  Future<void> setOpen(JobEntity job, bool open) async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    try {
      await ref.read(updateJobUseCaseProvider)(
        id: job.id,
        title: job.title,
        description: job.description,
        skills: job.skills,
        imageUrl: job.imageUrl,
        jobUrl: job.jobUrl,
        budget: job.budget,
        deadline: job.deadline,
        isOpen: open,
        category: job.category,
      );

      state = const AsyncData(null);
    } on JobFailure catch (e, st) {
      state = AsyncError(e, st);
    } catch (e, st) {
      state = AsyncError(const JobFailure('job_update_failed'), st);
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/job/service/job_provider.dart';

import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';
import 'package:notes_tasks/modules/job/presentation/providers/job_usecases_providers.dart';

// ✅ Feed
final jobsFeedStreamProvider = StreamProvider<List<JobEntity>>((ref) {
  return ref.watch(watchJobsFeedUseCaseProvider)();
});

// ✅ My jobs
final myJobsStreamProvider = StreamProvider<List<JobEntity>>((ref) {
  return ref.watch(watchMyJobsUseCaseProvider)();
});

// ✅ Job by id (خليه من service مباشر عادي)
final jobByIdStreamProvider =
    StreamProvider.family<JobEntity?, String>((ref, jobId) {
  return ref.read(jobsServiceProvider).watchJobById(jobId);
});

// ✅ Jobs by category open
final jobsByCategoryOpenStreamProvider =
    StreamProvider.family<List<JobEntity>, String>((ref, category) {
  return ref.read(jobsServiceProvider).watchJobsByCategoryAndOpen(
        category: category,
        isOpen: true,
      );
});

// ✅ Jobs by category previous/closed
final jobsByCategoryPreviousStreamProvider =
    StreamProvider.family<List<JobEntity>, String>((ref, category) {
  return ref.read(jobsServiceProvider).watchJobsByCategoryAndOpen(
        category: category,
        isOpen: false,
      );
});

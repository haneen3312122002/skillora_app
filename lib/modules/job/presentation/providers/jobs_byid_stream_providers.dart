import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/features/job/service/job_provider.dart';
import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';

/// ✅ Job by id
final jobByIdStreamProvider =
    StreamProvider.family<JobEntity?, String>((ref, jobId) {
  final service = ref.read(jobsServiceProvider);
  return service.watchJobById(jobId);
});

/// ✅ Jobs (Open) by category
final jobsByCategoryOpenStreamProvider =
    StreamProvider.family<List<JobEntity>, String>((ref, category) {
  final service = ref.read(jobsServiceProvider);
  return service.watchJobsByCategoryAndOpen(
    category: category,
    isOpen: true,
  );
});

/// ✅ Jobs (Previous/Closed) by category
final jobsByCategoryPreviousStreamProvider =
    StreamProvider.family<List<JobEntity>, String>((ref, category) {
  final service = ref.read(jobsServiceProvider);
  return service.watchJobsByCategoryAndOpen(
    category: category,
    isOpen: false,
  );
});

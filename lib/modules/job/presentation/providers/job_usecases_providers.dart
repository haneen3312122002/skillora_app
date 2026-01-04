import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/job/service/job_provider.dart';

import 'package:notes_tasks/modules/job/domain/usecases/add_job_usecase.dart';
import 'package:notes_tasks/modules/job/domain/usecases/delete_job_usecase.dart';
import 'package:notes_tasks/modules/job/domain/usecases/get_jobs_by_category_usecase.dart';
import 'package:notes_tasks/modules/job/domain/usecases/update_job_usecase.dart';
import 'package:notes_tasks/modules/job/domain/usecases/watch_jobs_feed_usecase.dart';
import 'package:notes_tasks/modules/job/domain/usecases/watch_my_jobs_usecase.dart';

final watchJobsFeedUseCaseProvider = Provider<WatchJobsFeedUseCase>((ref) {
  return WatchJobsFeedUseCase(ref.read(jobsServiceProvider));
});

final watchMyJobsUseCaseProvider = Provider<WatchMyJobsUseCase>((ref) {
  return WatchMyJobsUseCase(ref.read(jobsServiceProvider));
});

final addJobUseCaseProvider = Provider<AddJobUseCase>((ref) {
  return AddJobUseCase(ref.read(jobsServiceProvider));
});

final updateJobUseCaseProvider = Provider<UpdateJobUseCase>((ref) {
  return UpdateJobUseCase(ref.read(jobsServiceProvider));
});

final deleteJobUseCaseProvider = Provider<DeleteJobUseCase>((ref) {
  return DeleteJobUseCase(ref.read(jobsServiceProvider));
});

final watchJobsByCategoryUseCaseProvider =
    Provider<WatchJobsByCategoryUseCase>((ref) {
  return WatchJobsByCategoryUseCase(ref.read(jobsServiceProvider));
});

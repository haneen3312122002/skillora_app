import 'package:notes_tasks/core/services/job/service/jobs_service.dart';
import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';

class WatchMyJobsUseCase {
  final JobsService _service;
  WatchMyJobsUseCase(this._service);

  Stream<List<JobEntity>> call() => _service.watchMyJobs();
}

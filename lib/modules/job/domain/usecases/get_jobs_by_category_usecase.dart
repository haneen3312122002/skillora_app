import 'package:notes_tasks/core/services/job/service/jobs_service.dart';
import 'package:notes_tasks/modules/job/domain/entities/job_entity.dart';

class WatchJobsByCategoryUseCase {
  final JobsService _service;
  WatchJobsByCategoryUseCase(this._service);

  Stream<List<JobEntity>> call({
    required String category,
    required bool isOpen,
  }) {
    return _service.watchJobsByCategoryAndOpen(
        category: category, isOpen: isOpen);
  }
}

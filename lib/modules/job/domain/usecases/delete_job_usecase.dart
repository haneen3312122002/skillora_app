import 'package:notes_tasks/core/services/job/service/jobs_service.dart';

class DeleteJobUseCase {
  final JobsService _service;
  DeleteJobUseCase(this._service);

  Future<void> call(String id) => _service.deleteJob(id);
}

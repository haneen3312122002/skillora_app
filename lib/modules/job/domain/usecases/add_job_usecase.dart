import 'package:notes_tasks/core/services/job/service/jobs_service.dart';

class AddJobUseCase {
  final JobsService _service;
  AddJobUseCase(this._service);

  Future<String> call(
      {required String title,
      required String description,
      List<String> skills = const [],
      String? imageUrl,
      String? jobUrl,
      double? budget,
      DateTime? deadline,
      required String category}) {
    return _service.addJob(
        title: title,
        description: description,
        skills: skills,
        imageUrl: imageUrl,
        jobUrl: jobUrl,
        budget: budget,
        deadline: deadline,
        category: category);
  }
}

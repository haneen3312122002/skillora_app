import 'package:notes_tasks/core/services/job/service/jobs_service.dart';

class UpdateJobUseCase {
  final JobsService _service;
  UpdateJobUseCase(this._service);

  Future<void> call({
    required String id,
    required String title,
    required String category,
    required String description,
    List<String> skills = const [],
    String? imageUrl,
    String? jobUrl,
    double? budget,
    DateTime? deadline,
    bool? isOpen,
  }) {
    return _service.updateJob(
        id: id,
        title: title,
        description: description,
        skills: skills,
        imageUrl: imageUrl,
        jobUrl: jobUrl,
        budget: budget,
        deadline: deadline,
        isOpen: isOpen,
        category: category);
  }
}

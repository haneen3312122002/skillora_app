import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';
import 'package:notes_tasks/modules/profile_projects/data/models/project_model.dart';
import 'package:notes_tasks/modules/profile_projects/domain/entities/project_entity.dart';

final getProjectsStreamUseCaseProvider =
    Provider<GetProjectsStreamUseCase>((ref) {
  final service = ref.read(profileServiceProvider);
  return GetProjectsStreamUseCase(service);
});

class GetProjectsStreamUseCase {
  final ProfileService _service;
  GetProjectsStreamUseCase(this._service);

  Stream<List<ProjectEntity>> call() {
    return _service.watchProjectsMaps().map((items) {
      return items.map(ProjectModel.fromMap).toList();
    });
  }
}

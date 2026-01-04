import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final deleteProjectUseCaseProvider = Provider<DeleteProjectUseCase>((ref) {
  final service = ref.read(profileServiceProvider);
  return DeleteProjectUseCase(service);
});

class DeleteProjectUseCase {
  final ProfileService _service;
  DeleteProjectUseCase(this._service);

  Future<void> call(String id) {
    return _service.deleteProject(id);
  }
}
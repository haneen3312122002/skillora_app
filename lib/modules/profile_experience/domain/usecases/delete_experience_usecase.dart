import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final deleteExperienceUseCaseProvider =
    Provider<DeleteExperienceUseCase>((ref) {
  final profileService = ref.read(profileServiceProvider);
  return DeleteExperienceUseCase(profileService);
});

class DeleteExperienceUseCase {
  final ProfileService _service;

  DeleteExperienceUseCase(this._service);

  Future<void> call(String id) {
    return _service.deleteExperience(id);
  }
}
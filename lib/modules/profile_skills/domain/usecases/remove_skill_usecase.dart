import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final removeSkillUseCaseProvider = Provider<RemoveSkillUseCase>((ref) {
  final profileService = ref.read(profileServiceProvider);
  return RemoveSkillUseCase(profileService);
});

class RemoveSkillUseCase {
  final ProfileService _service;

  RemoveSkillUseCase(this._service);

  Future<void> call(String skill) {
    return _service.removeSkill(skill);
  }
}
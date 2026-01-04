import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final setSkillsUseCaseProvider = Provider<SetSkillsUseCase>((ref) {
  final profileService = ref.read(profileServiceProvider);
  return SetSkillsUseCase(profileService);
});

class SetSkillsUseCase {
  final ProfileService _service;

  SetSkillsUseCase(this._service);

  Future<void> call(List<String> skills) {
    return _service.setSkills(skills);
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final addExperienceUseCaseProvider = Provider<AddExperienceUseCase>((ref) {
  final profileService = ref.read(profileServiceProvider);
  return AddExperienceUseCase(profileService);
});

class AddExperienceUseCase {
  final ProfileService _service;

  AddExperienceUseCase(this._service);

  Future<String> call({
    required String title,
    required String company,
    DateTime? startDate,
    DateTime? endDate,
    required String location,
    required String description,
  }) {
    return _service.addExperience(
      title: title,
      company: company,
      startDate: startDate,
      endDate: endDate,
      location: location,
      description: description,
    );
  }
}
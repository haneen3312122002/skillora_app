import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final updateExperienceUseCaseProvider =
    Provider<UpdateExperienceUseCase>((ref) {
  final profileService = ref.read(profileServiceProvider);
  return UpdateExperienceUseCase(profileService);
});

class UpdateExperienceUseCase {
  final ProfileService _service;

  UpdateExperienceUseCase(this._service);

  Future<void> call({
    required String id,
    required String title,
    required String company,
    DateTime? startDate,
    DateTime? endDate,
    required String location,
    required String description,
  }) {
    return _service.updateExperience(
      id: id,
      title: title,
      company: company,
      startDate: startDate,
      endDate: endDate,
      location: location,
      description: description,
    );
  }
}
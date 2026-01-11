import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';
import 'package:notes_tasks/modules/profile_experience/data/models/experience_model.dart';
import 'package:notes_tasks/modules/profile_experience/domain/entities/experience_entity.dart';

final getExperiencesStreamUseCaseProvider =
    Provider<GetExperiencesStreamUseCase>((ref) {
  final service = ref.read(profileServiceProvider);
  return GetExperiencesStreamUseCase(service);
});

class GetExperiencesStreamUseCase {
  final ProfileService _service;
  GetExperiencesStreamUseCase(this._service);

  Stream<List<ExperienceEntity>> call(String uid) {
    // ✅
    return _service.watchExperiencesMaps(uid).map((items) {
      // ✅
      return items.map(ExperienceModel.fromMap).toList();
    });
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/profile_experience/domain/entities/experience_entity.dart';
import 'package:notes_tasks/modules/profile_experience/domain/usecases/get_experiences_stream_usecase.dart';

final experiencesStreamProvider =
    StreamProvider.family<List<ExperienceEntity>, String>((ref, uid) {
  final useCase = ref.watch(getExperiencesStreamUseCaseProvider);
  return useCase(uid); // ✅ لازم اليوزكيس يستقبل uid
});

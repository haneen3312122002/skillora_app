import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/profile_projects/domain/entities/project_entity.dart';
import 'package:notes_tasks/modules/profile_projects/domain/usecases/get_projects_stream_usecase.dart';

final projectsStreamProvider =
    StreamProvider.family<List<ProjectEntity>, String>((ref, uid) {
  final usecase = ref.watch(getProjectsStreamUseCaseProvider);
  return usecase(uid); // ✅
});

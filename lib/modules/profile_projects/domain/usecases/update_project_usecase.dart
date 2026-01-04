import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final updateProjectUseCaseProvider = Provider<UpdateProjectUseCase>((ref) {
  final service = ref.read(profileServiceProvider);
  return UpdateProjectUseCase(service);
});

class UpdateProjectUseCase {
  final ProfileService _service;
  UpdateProjectUseCase(this._service);

  Future<void> call({
    required String id,
    required String title,
    required String description,
    List<String> tools = const [],
    String? imageUrl,
    String? projectUrl,
  }) {
    return _service.updateProject(
      id: id,
      title: title,
      description: description,
      tools: tools,
      imageUrl: imageUrl,
      projectUrl: projectUrl,
    );
  }
}
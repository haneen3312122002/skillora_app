import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final addProjectUseCaseProvider = Provider<AddProjectUseCase>((ref) {
  final service = ref.read(profileServiceProvider);
  return AddProjectUseCase(service);
});

class AddProjectUseCase {
  final ProfileService _service;
  AddProjectUseCase(this._service);

  Future<String> call({
    required String title,
    required String description,
    List<String> tools = const [],
    String? imageUrl,
    String? projectUrl,
  }) {
    return _service.addProject(
      title: title,
      description: description,
      tools: tools,
      imageUrl: imageUrl,
      projectUrl: projectUrl,
    );
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final updateNameUseCaseProvider = Provider<UpdateNameUseCase>((ref) {
  final service = ref.read(profileServiceProvider);
  return UpdateNameUseCase(service);
});

class UpdateNameUseCase {
  final ProfileService _service;

  UpdateNameUseCase(this._service);

  Future<void> call(String name) {
    return _service.updateName(name);
  }
}
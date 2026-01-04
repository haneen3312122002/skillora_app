import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final updateEmailUseCaseProvider = Provider<UpdateEmailUseCase>((ref) {
  final service = ref.read(profileServiceProvider);
  return UpdateEmailUseCase(service);
});

class UpdateEmailUseCase {
  final ProfileService _service;

  UpdateEmailUseCase(this._service);

  Future<void> call(String email) {
    return _service.updateEmail(email);
  }
}
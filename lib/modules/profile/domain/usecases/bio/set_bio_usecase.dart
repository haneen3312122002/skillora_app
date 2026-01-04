import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final setBioUseCaseProvider = Provider<SetBioUseCase>((ref) {
  final profileService = ref.read(profileServiceProvider);
  return SetBioUseCase(profileService);
});

class SetBioUseCase {
  final ProfileService _service;

  SetBioUseCase(this._service);

  Future<void> call(String? bio) {
    return _service.setBio(bio);
  }
}
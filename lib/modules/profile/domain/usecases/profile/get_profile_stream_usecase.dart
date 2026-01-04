import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';
import 'package:notes_tasks/modules/profile/data/models/profile_model.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getProfileStreamUseCaseProvider =
    Provider<GetProfileStreamUseCase>((ref) {
  final service = ref.read(profileServiceProvider);
  return GetProfileStreamUseCase(service);
});

class GetProfileStreamUseCase {
  final ProfileService _service;

  GetProfileStreamUseCase(this._service);

  Stream<ProfileEntity?> call() {
    return _service.watchProfile().map((doc) {
      if (!doc.exists) return null;
      return ProfileModel.fromDoc(doc);
    });
  }
}

import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final uploadProfileImageUseCaseProvider =
    Provider<UploadProfileImageUseCase>((ref) {
  final service = ref.read(profileServiceProvider);
  return UploadProfileImageUseCase(service);
});

class UploadProfileImageUseCase {
  final ProfileService _service;

  UploadProfileImageUseCase(this._service);

  Future<String> call(Uint8List bytes) {
    return _service.uploadProfileImage(bytes);
  }
}

final uploadCoverImageUseCaseProvider =
    Provider<UploadCoverImageUseCase>((ref) {
  final service = ref.read(profileServiceProvider);
  return UploadCoverImageUseCase(service);
});

class UploadCoverImageUseCase {
  final ProfileService _service;

  UploadCoverImageUseCase(this._service);

  Future<String> call(Uint8List bytes) {
    return _service.uploadCoverImage(bytes);
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/shared/providers/image_picker_provider.dart';
import 'package:notes_tasks/core/shared/providers/local_image_storage_provider.dart';

final profileHeaderActionsViewModelProvider =
    Provider<ProfileHeaderActionsViewModel>((ref) {
  return ProfileHeaderActionsViewModel(ref);
});

class ProfileHeaderActionsViewModel {
  final Ref _ref;
  ProfileHeaderActionsViewModel(this._ref);

  Future<String?> changeAvatar({required String uid}) async {
    final picker = _ref.read(imagePickerServiceProvider);
    final bytes = await picker.pickFromGallery(imageQuality: 80);
    if (bytes == null) return 'cancelled';

    try {
      await _ref
          .read(localImageStorageProvider.notifier)
          .saveAvatar(uid: uid, bytes: bytes);
      return null;
    } catch (_) {
      return 'failed_with_error';
    }
  }

  Future<String?> changeCover({required String uid}) async {
    final picker = _ref.read(imagePickerServiceProvider);
    final bytes = await picker.pickFromGallery(imageQuality: 80);
    if (bytes == null) return 'cancelled';

    try {
      await _ref
          .read(localImageStorageProvider.notifier)
          .saveCover(uid: uid, bytes: bytes);
      return null;
    } catch (_) {
      return 'failed_with_error';
    }
  }
}

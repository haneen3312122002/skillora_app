import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/shared/providers/local_image_storage_provider.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/providers/image_picker_provider.dart';

final profileHeaderActionsViewModelProvider =
    Provider<ProfileHeaderActionsViewModel>((ref) {
  return ProfileHeaderActionsViewModel(ref);
});

class ProfileHeaderActionsViewModel {
  final Ref _ref;

  ProfileHeaderActionsViewModel(this._ref);

  Future<void> changeAvatar(BuildContext context, {required String uid}) async {
    final picker = _ref.read(imagePickerServiceProvider);
    final Uint8List? bytes = await picker.pickFromGallery(imageQuality: 80);
    if (bytes == null) return;

    await _ref.read(localImageStorageProvider.notifier).saveAvatar(
          uid: uid,
          bytes: bytes,
        );

    if (!context.mounted) return;
    AppSnackbar.show(context, 'profile_image_updated'.tr());
  }

  Future<void> changeCover(BuildContext context, {required String uid}) async {
    final picker = _ref.read(imagePickerServiceProvider);
    final Uint8List? bytes = await picker.pickFromGallery(imageQuality: 80);
    if (bytes == null) return;

    await _ref.read(localImageStorageProvider.notifier).saveCover(
          uid: uid,
          bytes: bytes,
        );

    if (!context.mounted) return;
    AppSnackbar.show(context, 'cover_image_updated'.tr());
  }
}

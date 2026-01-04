// lib/modules/profile/presentation/services/profile_actions_helpers.dart
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/shared/providers/image_picker_provider.dart';

import 'package:notes_tasks/core/shared/providers/local_image_storage_provider.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';

Future<void> pickAndUploadAvatar(
  BuildContext context,
  WidgetRef ref, {
  required String uid,
}) async {
  final picker = ref.read(imagePickerServiceProvider);

  final Uint8List? bytes =
      await picker.pickFromGallery(imageQuality: 80); // أو الكاميرا لو حاب

  if (bytes == null) return;

  await ref
      .read(localImageStorageProvider.notifier)
      .saveAvatar(uid: uid, bytes: bytes);

  AppSnackbar.show(context, 'profile_image_updated'.tr());
}

Future<void> pickAndUploadCover(
  BuildContext context,
  WidgetRef ref, {
  required String uid,
}) async {
  final picker = ref.read(imagePickerServiceProvider);
  final Uint8List? bytes = await picker.pickFromGallery(imageQuality: 80);

  if (bytes == null) return;

  await ref
      .read(localImageStorageProvider.notifier)
      .saveCover(uid: uid, bytes: bytes);

  AppSnackbar.show(context, 'cover_image_updated'.tr());
}

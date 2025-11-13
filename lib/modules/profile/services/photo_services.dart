import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/UploadCoverImageViewModel.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/UploadProfileImageViewModel.dart';
import 'package:image_picker/image_picker.dart';

Future<void> pickAndUploadAvatar(BuildContext context, WidgetRef ref) async {
  final picker = ImagePicker();
  final picked =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
  if (picked == null) return;

  final bytes = await picked.readAsBytes();
  await ref
      .read(uploadProfileImageViewModelProvider.notifier)
      .submit(context, bytes: bytes);
}

Future<void> pickAndUploadCover(BuildContext context, WidgetRef ref) async {
  final picker = ImagePicker();
  final picked =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
  if (picked == null) return;

  final bytes = await picked.readAsBytes();
  await ref
      .read(uploadCoverImageViewModelProvider.notifier)
      .submit(context, bytes: bytes);
}

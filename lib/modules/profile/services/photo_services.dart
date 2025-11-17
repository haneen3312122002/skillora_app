import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/widgets/app_dialog.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/UpdateEmailViewModel.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/UpdateNameViewModel.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/UploadCoverImageViewModel.dart';
import 'package:notes_tasks/modules/profile/presentation/viewmodels/UploadProfileImageViewModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_tasks/modules/profile/presentation/widgets/edit_field_dialog_content.dart';

Future<void> pickAndUploadAvatar(BuildContext context, WidgetRef ref) async {
  final picker = ImagePicker();
  final picked =
      await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
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

void showEditNameDialog(
    BuildContext context, WidgetRef ref, Map<String, dynamic> profile) {
  final controller = TextEditingController(text: profile['name']);

  AppDialog.show(
    context: context,
    title: 'Edit name',
    content: EditFieldDialogContent(
      controller: controller,
      label: 'Name',
      onSave: (value) async {
        await ref
            .read(updateNameViewModelProvider.notifier)
            .submit(context, rawName: value);
      },
    ),
  );
}

void showEditEmailDialog(
    BuildContext context, WidgetRef ref, Map<String, dynamic> profile) {
  final controller = TextEditingController(text: profile['email']);

  AppDialog.show(
    context: context,
    title: 'Edit email',
    content: EditFieldDialogContent(
      controller: controller,
      label: 'Email',
      keyboardType: TextInputType.emailAddress,
      onSave: (value) async {
        await ref
            .read(updateEmailViewModelProvider.notifier)
            .submit(context, rawEmail: value);
      },
    ),
  );
}

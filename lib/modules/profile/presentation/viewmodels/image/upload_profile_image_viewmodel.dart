// lib/modules/profile/presentation/viewmodels/image/upload_profile_image_viewmodel.dart
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/providers/local_image_storage_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';

final uploadProfileImageViewModelProvider =
    AsyncNotifierProvider<UploadProfileImageViewModel, Uint8List?>(
  UploadProfileImageViewModel.new,
);

class UploadProfileImageViewModel extends AsyncNotifier<Uint8List?> {
  late final String _uid;

  @override
  FutureOr<Uint8List?> build() {
    // نجيب اليوزر الحالي
    final profileService = ref.read(profileServiceProvider);
    final user = profileService.auth.currentUser;
    if (user == null) {
      return null;
    }

    _uid = user.uid;

    // نجيب الأفاتار الخاص بهاليوزر
    final localState = ref.watch(localImageStorageProvider);
    return localState.avatarFor(_uid);
  }

  Future<String?> submit({required Uint8List bytes}) async {
    if (state.isLoading) return 'something_went_wrong';
    state = const AsyncLoading();

    try {
      await ref
          .read(localImageStorageProvider.notifier)
          .saveAvatar(uid: _uid, bytes: bytes);

      state = AsyncData(bytes);
      return null;
    } catch (e, st) {
      state = AsyncError(e, st);
      return 'failed_with_error';
    }
  }
}

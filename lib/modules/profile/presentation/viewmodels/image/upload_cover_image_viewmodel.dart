// lib/modules/profile/presentation/viewmodels/image/upload_cover_image_viewmodel.dart
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:notes_tasks/core/shared/widgets/common/app_snackbar.dart';
import 'package:notes_tasks/core/shared/providers/local_image_storage_provider.dart';
import 'package:notes_tasks/core/services/profile/services/profile_provider.dart';

final uploadCoverImageViewModelProvider =
    AsyncNotifierProvider<UploadCoverImageViewModel, Uint8List?>(
  UploadCoverImageViewModel.new,
);

class UploadCoverImageViewModel extends AsyncNotifier<Uint8List?> {
  late final String _uid;

  @override
  FutureOr<Uint8List?> build() {
    // نجيب اليوزر الحالي
    final profileService = ref.read(profileServiceProvider);
    final user = profileService.auth.currentUser;
    if (user == null) {
      // مش مسجّل → ما في صورة
      return null;
    }

    _uid = user.uid;

    // نجيب الكفر الخاص بهاليوزر من الـ localImageStorage
    final localState = ref.watch(localImageStorageProvider);
    return localState.coverFor(_uid);
  }

  Future<String?> submit({required Uint8List bytes}) async {
    if (state.isLoading) return 'something_went_wrong';
    state = const AsyncLoading();

    try {
      await ref
          .read(localImageStorageProvider.notifier)
          .saveCover(uid: _uid, bytes: bytes);

      state = AsyncData(bytes);
      return null;
    } catch (e, st) {
      state = AsyncError(e, st);
      return 'failed_with_error';
    }
  }
}

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/providers/firebase/profile/profile_provider.dart';


final uploadProfileImageViewModelProvider =
    AsyncNotifierProvider<UploadProfileImageViewModel, String?>(
  UploadProfileImageViewModel.new,
);

class UploadProfileImageViewModel extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() async => null;

  Future<void> submit(
    BuildContext context, {
    required Uint8List bytes,
  }) async {
    if (state.isLoading) return;

    state = const AsyncLoading();
    try {
      final svc = ref.read(profileServiceProvider);
      final url = await svc.uploadProfileImage(bytes);
      state = AsyncData(url);
      _snack(context, 'Profile image updated');
    } catch (e, st) {
      state = AsyncError(e, st);
      _snack(context, 'Failed: $e');
    }
  }

  void _snack(BuildContext c, String m) =>
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));
}


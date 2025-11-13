import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/providers/firebase/profile/profile_provider.dart';


final updateEmailViewModelProvider =
    AsyncNotifierProvider<UpdateEmailViewModel, String?>(
  UpdateEmailViewModel.new,
);

class UpdateEmailViewModel extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() async => null;

  Future<void> submit(BuildContext context, {required String rawEmail}) async {
    if (state.isLoading) return;

    final email = rawEmail.trim();
    if (email.isEmpty) {
      _snack(context, 'Please enter an email');
      return;
    }

    FocusScope.of(context).unfocus();
    state = const AsyncLoading();

    try {
      final svc = ref.read(profileServiceProvider);
      await svc.updateEmail(email);
      state = AsyncData(email);
      _snack(context, 'Verification email sent to $email');
    } catch (e, st) {
      state = AsyncError(e, st);
      _snack(context, 'Failed: $e');
    }
  }

  void _snack(BuildContext c, String m) =>
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));
}


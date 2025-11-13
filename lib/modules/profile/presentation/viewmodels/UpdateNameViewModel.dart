import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/providers/firebase/profile/profile_provider.dart';

final updateNameViewModelProvider =
    AsyncNotifierProvider<UpdateNameViewModel, String?>(
  UpdateNameViewModel.new,
);

class UpdateNameViewModel extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() async => null;

  Future<void> submit(BuildContext context, {required String rawName}) async {
    if (state.isLoading) return;

    final name = rawName.trim();
    if (name.isEmpty) {
      _snack(context, 'Please enter a name');
      return;
    }

    FocusScope.of(context).unfocus();
    state = const AsyncLoading();

    try {
      final svc = ref.read(profileServiceProvider);
      await svc.updateName(name);
      state = AsyncData(name);
      _snack(context, 'Name updated');
    } catch (e, st) {
      state = AsyncError(e, st);
      _snack(context, 'Failed: $e');
    }
  }

  void _snack(BuildContext c, String m) =>
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));
}


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:notes_tasks/core/services/firebase/firebase_providers.dart';

// ✅ اسم مزوّد واضح ومميز لتتبّعه في اللوج
final firebaseLoginVMProvider =
    AsyncNotifierProvider<FirebaseLoginViewModel, fb.User?>(
  FirebaseLoginViewModel.new,
  name: 'FirebaseLoginVM',
);

class FirebaseLoginViewModel extends AsyncNotifier<fb.User?> {
  @override
  FutureOr<fb.User?> build() async => null;

  Future<void> login({required String email, required String password}) async {
    if (state.isLoading) return;
    debugPrint('[VM] login() called email=$email');
    state = const AsyncLoading();
    try {
      final auth = ref.read(authServiceProvider);
      debugPrint('[VM] got authService=$auth');
      final cred = await auth.login(email: email, password: password);
      debugPrint('[VM] service returned uid=${cred.user?.uid}');
      state = AsyncData(cred.user);
    } on fb.FirebaseAuthException catch (e, st) {
      debugPrint('[VM] FirebaseAuthException code=${e.code} msg=${e.message}');
      state = AsyncError(e, st);
    } catch (e, st) {
      debugPrint('[VM] Unknown error: $e');
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      await ref.read(authServiceProvider).logout();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

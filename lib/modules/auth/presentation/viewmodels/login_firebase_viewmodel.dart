import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/services/auth/mappers/firebase_auth_failure_mapper.dart';
import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';
import 'package:notes_tasks/modules/auth/domain/usecases/login_usecase.dart';
import 'package:notes_tasks/modules/auth/domain/usecases/logout_usecase.dart';

import 'package:notes_tasks/core/services/auth/account_switcher/saved_accounts_service.dart';
import 'package:notes_tasks/core/services/auth/account_switcher/saved_accounts_provider.dart';

final firebaseLoginVMProvider =
    AsyncNotifierProvider<FirebaseLoginViewModel, void>(
  FirebaseLoginViewModel.new,
  name: 'FirebaseLoginVM',
);

class FirebaseLoginViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {
    return;
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    try {
      final loginUseCase = ref.read(firebaseLoginUseCaseProvider);
      await loginUseCase(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = fb.FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await _saveAccountLocally(uid: uid, email: email.trim());
      }

      state = const AsyncData(null);
    } catch (e, st) {
      final failure = (e is AuthFailure)
          ? e
          : mapFirebaseExceptionToAuthFailure(e as Object) ??
              const AuthFailure('something_went_wrong');

      state = AsyncError(failure, st);
    }
  }

  Future<void> logout() async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    try {
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      await logoutUseCase();
      state = const AsyncData(null);
    } catch (e, st) {
      final failure = (e is AuthFailure)
          ? e
          : mapFirebaseExceptionToAuthFailure(e as Object) ??
              const AuthFailure('something_went_wrong');

      state = AsyncError(failure, st);
    }
  }

  Future<void> _saveAccountLocally({
    required String uid,
    required String email,
  }) async {
    try {
      final db = ref.read(firebaseFirestoreProvider);

      final userSnap = await db.collection('users').doc(uid).get();
      final data = userSnap.data() ?? {};

      final name = (data['name'] ?? '').toString();
      final role = (data['role'] ?? '').toString();

      final service = ref.read(savedAccountsServiceProvider);

      await service.upsert(
        SavedAccount(
          uid: uid,
          email: email,
          name: name.isNotEmpty ? name : email,
          role: role.isNotEmpty ? role : 'user',
          lastUsedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      ref.invalidate(savedAccountsProvider);
    } catch (_) {
      // don't block login if saving account fails
    }
  }
}

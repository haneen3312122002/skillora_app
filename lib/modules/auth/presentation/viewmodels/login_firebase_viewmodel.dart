import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/services/auth/mappers/firebase_auth_failure_mapper.dart';
import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';
import 'package:notes_tasks/modules/auth/domain/usecases/login_usecase.dart';
import 'package:notes_tasks/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:notes_tasks/modules/auth/domain/usecases/save_account.dart';

final firebaseLoginVMProvider =
    AsyncNotifierProvider<FirebaseLoginViewModel, void>(
  FirebaseLoginViewModel.new,
  name: 'FirebaseLoginVM',
);

class FirebaseLoginViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async => null;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    try {
      final loginUseCase = ref.read(firebaseLoginUseCaseProvider);
      await loginUseCase(email: email, password: password);

      // ✅ save account (non-blocking)
      unawaited(
        ref.read(saveAccountLocallyUseCaseProvider).call(email: email.trim()),
      );

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
}

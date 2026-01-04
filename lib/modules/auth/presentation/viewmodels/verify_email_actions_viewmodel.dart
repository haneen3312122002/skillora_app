import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/services/auth/mappers/firebase_auth_failure_mapper.dart';
import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';

final verifyEmailActionsVMProvider =
    AsyncNotifierProvider<VerifyEmailActionsViewModel, void>(
  VerifyEmailActionsViewModel.new,
  name: 'VerifyEmailActionsVM',
);

class VerifyEmailActionsViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {
    return;
  }

  Future<void> resendVerification() async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    try {
      final authService = ref.read(authServiceProvider);
      await authService
          .sendEmailVerification()
          .timeout(const Duration(seconds: 20));

      state = const AsyncData(null);
    } on TimeoutException {
      state =
          AsyncError(const AuthFailure('request_timeout'), StackTrace.current);
    } catch (e, st) {
      final failure = mapFirebaseExceptionToAuthFailure(e as Object);
      state =
          AsyncError(failure ?? const AuthFailure('something_went_wrong'), st);
    }
  }

  Future<void> logout() async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    try {
      final authService = ref.read(authServiceProvider);
      await authService.logout().timeout(const Duration(seconds: 20));
      state = const AsyncData(null);
    } on TimeoutException {
      state =
          AsyncError(const AuthFailure('request_timeout'), StackTrace.current);
    } catch (e, st) {
      final failure = mapFirebaseExceptionToAuthFailure(e as Object);
      state =
          AsyncError(failure ?? const AuthFailure('something_went_wrong'), st);
    }
  }
}

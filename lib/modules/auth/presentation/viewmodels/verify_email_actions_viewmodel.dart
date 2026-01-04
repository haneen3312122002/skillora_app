// ===============================
// verify_email_actions_viewmodel.dart
// modules/auth/presentation/viewmodels/verify_email_actions_viewmodel.dart
// ===============================
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/services/auth/auth_service.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/modules/auth/data/mappers/firebase_auth_failure_mapper.dart';
import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';

sealed class VerifyEmailEffect {
  const VerifyEmailEffect();
}

class VerifyEmailSuccessEffect extends VerifyEmailEffect {
  final String messageKey;
  const VerifyEmailSuccessEffect(this.messageKey);
}

final verifyEmailActionsVMProvider =
    AsyncNotifierProvider<VerifyEmailActionsViewModel, VerifyEmailEffect?>(
  VerifyEmailActionsViewModel.new,
  name: 'VerifyEmailActionsVM',
);

class VerifyEmailActionsViewModel extends AsyncNotifier<VerifyEmailEffect?> {
  @override
  FutureOr<VerifyEmailEffect?> build() async => null;

  Future<void> resendVerification() async {
    if (state.isLoading) return;
    state = const AsyncLoading();

    try {
      final AuthService authService = ref.read(authServiceProvider);

      await authService
          .sendEmailVerification()
          .timeout(const Duration(seconds: 20));

      // ✅ Emit effect (UI will show snackbar via listener)
      state =
          const AsyncData(VerifyEmailSuccessEffect('verification_email_sent'));

      // Optional: reset to null so effect won't repeat if UI re-listens later
      // (Useful if you navigate back to this screen)
      // state = const AsyncData(null);
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
      final AuthService authService = ref.read(authServiceProvider);
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

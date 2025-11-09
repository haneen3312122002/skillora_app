import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:notes_tasks/core/providers/firebase/firebase_providers.dart';

class ResetPasswordFailure implements Exception {
  final String messageKey;
  const ResetPasswordFailure(this.messageKey);

  @override
  String toString() => 'ResetPasswordFailure($messageKey)';
}

final resetPasswordViewModelProvider =
    AsyncNotifierProvider<ResetPasswordViewModel, void>(
  ResetPasswordViewModel.new,
);

class ResetPasswordViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {
    return;
  }

  Future<void> sendResetEmail({
    required String email,
  }) async {
    if (state.isLoading) {
      debugPrint(
          '[ResetPasswordVM] Ignored duplicate sendResetEmail() while loading');
      return;
    }

    debugPrint('[ResetPasswordVM] Start sendResetEmail: email=$email');

    if (email.isEmpty) {
      debugPrint('[ResetPasswordVM] Validation failed: empty email');
      state = AsyncError(
        const ResetPasswordFailure('please_enter_email'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    try {
      final fb.FirebaseAuth auth = ref.read(firebaseAuthProvider);

      await auth
          .sendPasswordResetEmail(email: email)
          .timeout(const Duration(seconds: 20), onTimeout: () {
        throw TimeoutException('sendPasswordResetEmail() timed out after 20s');
      });

      debugPrint('[ResetPasswordVM] sendResetEmail() completed for $email');

      state = const AsyncData(null);
    } on fb.FirebaseAuthException catch (e, st) {
      debugPrint(
          '[ResetPasswordVM] FirebaseAuthException: ${e.code} - ${e.message}');
      final messageKey = _mapFirebaseErrorToMessageKey(e);
      state = AsyncError(ResetPasswordFailure(messageKey), st);
    } on TimeoutException catch (e, st) {
      debugPrint('[ResetPasswordVM] TimeoutException: ${e.message}');
      state = const AsyncError(
        ResetPasswordFailure('request_timeout'),
        StackTrace.empty,
      );
    } catch (e, st) {
      debugPrint('[ResetPasswordVM] Unknown error: $e');
      state = const AsyncError(
        ResetPasswordFailure('something_went_wrong'),
        StackTrace.empty,
      );
    }
  }

  String _mapFirebaseErrorToMessageKey(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'user_not_found';
      case 'invalid-email':
        return 'invalid_email';
      case 'missing-email':
        return 'please_enter_email';
      case 'network-request-failed':
        return 'network_error';
      default:
        return 'something_went_wrong';
    }
  }
}

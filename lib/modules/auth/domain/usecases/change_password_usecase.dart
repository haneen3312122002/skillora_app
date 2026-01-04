import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/services/auth/services/auth_service.dart';
import 'package:notes_tasks/core/services/auth/mappers/firebase_auth_failure_mapper.dart';

import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';
import 'package:notes_tasks/modules/auth/domain/validators/auth_validators.dart';

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>((ref) {
  final authService = ref.read(authServiceProvider);
  return ChangePasswordUseCase(authService);
});

class ChangePasswordUseCase {
  final AuthService _authService;
  ChangePasswordUseCase(this._authService);

  Future<void> call({required String currentPassword}) async {
    final passKey = AuthValidators.validatePassword(currentPassword);
    if (passKey != null) throw AuthFailure(passKey);

    final user = _authService.auth.currentUser;
    if (user == null) throw const AuthFailure('not_authenticated');

    final email = user.email;
    if (email == null || email.isEmpty) {
      throw const AuthFailure('no_email_for_user');
    }

    try {
      await _authService
          .reauthenticateWithCurrentPassword(currentPassword: currentPassword)
          .timeout(const Duration(seconds: 20));

      await _authService
          .sendPasswordResetEmail(email: email)
          .timeout(const Duration(seconds: 20));
    } on TimeoutException {
      throw const AuthFailure('request_timeout');
    } catch (e) {
      // wrong-current-password: Firebase يبعث wrong-password عادة
      final failure = mapFirebaseExceptionToAuthFailure(e as Object);
      if (failure != null) {
        if (failure.messageKey == 'wrong_password') {
          throw const AuthFailure('wrong_current_password');
        }
        throw failure;
      }

      throw const AuthFailure('something_went_wrong');
    }
  }
}

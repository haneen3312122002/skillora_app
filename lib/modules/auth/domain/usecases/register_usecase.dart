import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/services/auth/services/auth_service.dart';
import 'package:notes_tasks/core/services/auth/mappers/firebase_auth_failure_mapper.dart';

import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';
import 'package:notes_tasks/modules/auth/domain/validators/auth_validators.dart';

final firebaseRegisterUseCaseProvider =
    Provider<FirebaseRegisterUseCase>((ref) {
  final authService = ref.read(authServiceProvider);
  return FirebaseRegisterUseCase(authService);
});

class FirebaseRegisterUseCase {
  final AuthService _authService;
  FirebaseRegisterUseCase(this._authService);

  Future<void> call({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final emailKey = AuthValidators.validateEmail(email);
    if (emailKey != null) throw AuthFailure(emailKey);

    final passKey = AuthValidators.validatePassword(password);
    if (passKey != null) throw AuthFailure(passKey);

    final trimmedName = name.trim();
    if (trimmedName.isEmpty) throw const AuthFailure('please_enter_name');

    try {
      final cred = await _authService
          .register(
            name: trimmedName,
            email: email.trim(),
            password: password.trim(),
            role: role,
          )
          .timeout(const Duration(seconds: 20));

      final user = cred.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on TimeoutException {
      throw const AuthFailure('request_timeout');
    } catch (e) {
      final failure = mapFirebaseExceptionToAuthFailure(e as Object);
      if (failure != null) throw failure;
      throw const AuthFailure('something_went_wrong');
    }
  }
}

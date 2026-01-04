import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:notes_tasks/modules/auth/domain/failures/auth_failure.dart';

/// Map Firebase auth exceptions to **security-safe, generic messages**
/// Do NOT expose internal auth details to the UI.
AuthFailure? mapFirebaseExceptionToAuthFailure(Object error) {
  if (error is! fb.FirebaseAuthException) return null;

  switch (error.code) {
    // 🔐 Authentication failures → ONE generic message
    case 'invalid-email':
    case 'user-not-found':
    case 'wrong-password':
    case 'user-disabled':
    case 'missing-email':
      return const AuthFailure('invalid_credentials');

    // 🔁 Rate limiting / abuse protection
    case 'too-many-requests':
      return const AuthFailure('too_many_attempts');

    // 🌐 Network / connectivity
    case 'network-request-failed':
      return const AuthFailure('network_error');

    // ❓ Fallback (never leak details)
    default:
      return const AuthFailure('auth_failed');
  }
}

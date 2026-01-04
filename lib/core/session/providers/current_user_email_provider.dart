// ===============================
// current_user_email_provider.dart
// core/session/providers/current_user_email_provider.dart
// ===============================
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';

final currentUserEmailProvider = Provider<String>((ref) {
  final auth = ref.read(firebaseAuthProvider);
  return auth.currentUser?.email ?? '';
});

// ===============================
// current_user_provider.dart
// core/session/providers/current_user_provider.dart
// ===============================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';

final currentUserProvider = Provider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.currentUser;
});
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(currentUserProvider)?.uid;
});

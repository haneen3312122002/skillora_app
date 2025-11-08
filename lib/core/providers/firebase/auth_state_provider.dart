// lib/core/providers/auth_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:notes_tasks/core/providers/firebase/firebase_providers.dart';

/// Stream of Firebase user auth state (null when signed out).
final authStateProvider = StreamProvider<fb.User?>((ref) {
  final auth = ref.read(firebaseAuthProvider); // ✅ استخدم مزوّدك
  return auth.authStateChanges();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_tasks/modules/auth/data/firebase/auth_service.dart';

//main providers:
final firebaseAuthProvider =
    Provider<fb.FirebaseAuth>((_) => fb.FirebaseAuth.instance);

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((_) => FirebaseFirestore.instance);

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    auth: ref.read(firebaseAuthProvider),
    db: ref.read(firebaseFirestoreProvider),
  );
});

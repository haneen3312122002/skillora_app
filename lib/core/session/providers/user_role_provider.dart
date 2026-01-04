import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';

final userRoleProvider = FutureProvider<UserRole>((ref) async {
  final auth = ref.read(firebaseAuthProvider);
  final db = ref.read(firebaseFirestoreProvider);

  final user = auth.currentUser;
  if (user == null) return UserRole.client;

  final doc = await db.collection('users').doc(user.uid).get();
  final data = doc.data();
  final rawRole = data?['role'] as String?;
  return parseUserRole(rawRole);
});

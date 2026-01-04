import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';

final userByIdDataStreamProvider =
    StreamProvider.family<Map<String, dynamic>?, String>((ref, uid) {
  final db = ref.read(firebaseFirestoreProvider);
  return db.collection('users').doc(uid).snapshots().map((doc) => doc.data());
});

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final markNotificationReadUseCaseProvider =
    Provider<MarkNotificationReadUseCase>((ref) {
  return MarkNotificationReadUseCase(
    db: FirebaseFirestore.instance,
    auth: fb.FirebaseAuth.instance,
  );
});

class MarkNotificationReadUseCase {
  MarkNotificationReadUseCase({required this.db, required this.auth});

  final FirebaseFirestore db;
  final fb.FirebaseAuth auth;

  Future<void> call(String notificationId) async {
    final u = auth.currentUser;
    if (u == null) throw Exception('No user');

    await db
        .collection('users')
        .doc(u.uid)
        .collection('notifications')
        .doc(notificationId)
        .set({'read': true}, SetOptions(merge: true));
  }
}

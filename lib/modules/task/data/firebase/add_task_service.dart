import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class AddTaskService {
  final FirebaseFirestore db;
  final fb.FirebaseAuth auth;
  AddTaskService({required this.db, required this.auth});

  Future<String> addTask({required String title, bool done = false}) async {
    final u = auth.currentUser;
    if (u == null) throw StateError('Not authenticated');
    final ref =
        await db.collection('users').doc(u.uid).collection('tasks').add({
      'title': title,
      'done': done,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id; // استخدم docId كسلسلة
  }
}

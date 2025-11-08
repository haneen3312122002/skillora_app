import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../../domain/entities/task_entity.dart';

class GetTasksService {
  final FirebaseFirestore db;
  final fb.FirebaseAuth auth;
  GetTasksService({required this.db, required this.auth});

  Stream<List<TaskEntity>> streamTasks() {
    final u = auth.currentUser;
    if (u == null) {
      // يُفضّل بدل الرمي إرجاع Stream.empty() حتى لا تكسر UI قبل Auth
      return const Stream.empty();
    }
    return db
        .collection('users')
        .doc(u.uid)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final m = d.data();
              return TaskEntity(
                id: d.id, // ✔ String docId
                todo: (m['title'] ?? '') as String,
                completed: (m['done'] ?? false) as bool,
                userId: u.uid, // لو بدّك uid كسلسلة؛ غيّر نوعه بالكيان
              );
            }).toList());
  }
}

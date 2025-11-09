import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_tasks/modules/task/domain/entities/task_entity.dart';

class TaskService {
  final fb.FirebaseAuth auth;
  final FirebaseFirestore db;

  TaskService({required this.auth, required this.db});
//get tasks:
  Stream<List<TaskEntity>> streamTasks() {
    final u = auth.currentUser;
    if (u == null) {
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
                userId: u.uid, //
              );
            }).toList());
  }

//add task
  Future<String> addTask({required String title, bool done = false}) async {
    final u = auth.currentUser;
    if (u == null) throw StateError('Not authenticated');
    final ref =
        await db.collection('users').doc(u.uid).collection('tasks').add({
      'title': title,
      'done': done,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }
  //update task
}

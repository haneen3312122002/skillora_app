import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/providers/firebase/firebase_providers.dart';
import 'package:notes_tasks/core/services/firebase/task_services/task_services.dart';

final TaskServiceProvider = Provider<TaskService>((ref) {
  return TaskService(
    db: ref.read(firebaseFirestoreProvider),
    auth: ref.read(firebaseAuthProvider),
  );
});

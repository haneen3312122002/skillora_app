import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/firebase/firebase_providers.dart';
import '../../../data/firebase/add_task_service.dart';

final addTaskServiceProvider = Provider<AddTaskService>((ref) {
  return AddTaskService(
    db: ref.read(firebaseFirestoreProvider),
    auth: ref.read(firebaseAuthProvider),
  );
});

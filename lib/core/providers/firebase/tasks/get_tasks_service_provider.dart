import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/providers/firebase/firebase_providers.dart';
import '../../../services/firebase/task_services/get_tasks_service.dart';

final getTasksServiceProvider = Provider<GetTasksService>((ref) {
  return GetTasksService(
    db: ref.read(firebaseFirestoreProvider),
    auth: ref.read(firebaseAuthProvider),
  );
});

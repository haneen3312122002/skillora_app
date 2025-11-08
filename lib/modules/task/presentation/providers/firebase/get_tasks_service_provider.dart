import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/services/firebase/firebase_providers.dart';
import '../../../data/firebase/get_tasks_service.dart';

final getTasksServiceProvider = Provider<GetTasksService>((ref) {
  return GetTasksService(
    db: ref.read(firebaseFirestoreProvider),
    auth: ref.read(firebaseAuthProvider),
  );
});

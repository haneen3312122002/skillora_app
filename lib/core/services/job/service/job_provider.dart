import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/services/job/service/jobs_service.dart';

final jobsServiceProvider = Provider<JobsService>((ref) {
  return JobsService(
    auth: ref.read(firebaseAuthProvider),
    db: ref.read(firebaseFirestoreProvider),
  );
});

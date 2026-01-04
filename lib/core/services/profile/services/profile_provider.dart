import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/services/profile/services/profile_service.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService(
    auth: ref.read(firebaseAuthProvider),
    db: ref.read(firebaseFirestoreProvider),
    storage: ref.read(firebaseStorageProvider),
  );
});

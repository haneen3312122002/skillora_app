import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/providers/firebase/profile/profile_provider.dart';

final profileStreamProvider =
    StreamProvider<Map<String, dynamic>?>((ref) async* {
  final svc = ref.watch(profileServiceProvider);
  yield* svc.watchProfile().map((doc) {
    if (!doc.exists) return null;
    final data = doc.data() ?? {};
    return {
      'uid': doc.id,
      'name': data['name'],
      'email': data['email'],
      'photoUrl': data['photoUrl'],
      'coverUrl': data['coverUrl'],
    };
  });
});

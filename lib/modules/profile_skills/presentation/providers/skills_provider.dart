import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/get_profile_stream_provider.dart';

final skillsProvider = Provider.family<List<String>, String>((ref, uid) {
  final profileAsync = ref.watch(profileStreamProvider(uid));

  return profileAsync.maybeWhen(
    data: (profile) => profile?.skills ?? const <String>[],
    orElse: () => const <String>[],
  );
});

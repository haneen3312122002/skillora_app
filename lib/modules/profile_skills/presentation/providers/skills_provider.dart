import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/get_profile_stream_provider.dart';

final skillsProvider = Provider<List<String>>((ref) {
  final profile = ref.watch(profileStreamProvider).value;
  return profile?.skills ?? const <String>[];
});

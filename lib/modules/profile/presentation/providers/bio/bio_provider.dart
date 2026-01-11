import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/get_profile_stream_provider.dart';

final bioProvider = Provider<String>((ref) {
  final uid = ref.watch(effectiveProfileUidProvider);

  if (uid == null) return '';

  final profileAsync = ref.watch(profileStreamProvider(uid));

  return profileAsync.maybeWhen(
    data: (profile) => profile?.bio ?? '',
    orElse: () => '',
  );
});

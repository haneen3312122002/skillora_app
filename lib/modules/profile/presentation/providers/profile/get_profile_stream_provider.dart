import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';
import 'package:notes_tasks/modules/profile/domain/usecases/profile/get_profile_stream_usecase.dart';
import 'package:notes_tasks/core/session/providers/current_user_provider.dart';

final profileStreamProvider =
    StreamProvider.family<ProfileEntity?, String?>((ref, uid) {
  if (uid == null || uid.trim().isEmpty) {
    return const Stream<ProfileEntity?>.empty();
  }
  final useCase = ref.watch(getProfileStreamUseCaseProvider);
  return useCase(uid);
});

/// هذا هو الـ UID للبروفايل اللي بدنا نعرضه.
/// رح نغيّره من أي شاشة (مثلاً من UsersAdminScreen) قبل ما نروح للبروفايل.
final viewedProfileUidProvider = StateProvider<String?>((ref) => null);

final effectiveProfileUidProvider = Provider<String?>((ref) {
  final overrideUid = ref.watch(viewedProfileUidOverrideProvider);
  if (overrideUid != null && overrideUid.isNotEmpty) return overrideUid;

  return ref.watch(currentUserIdProvider);
});
final canEditProfileProvider = Provider<bool>((ref) {
  final me = ref.watch(currentUserIdProvider);
  final viewed = ref.watch(effectiveProfileUidProvider);
  return me != null && viewed != null && me == viewed;
});
final viewedProfileUidOverrideProvider = Provider<String?>((ref) => null);

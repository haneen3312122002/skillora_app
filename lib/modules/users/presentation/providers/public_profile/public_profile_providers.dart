import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';
import 'package:notes_tasks/modules/profile/domain/usecases/profile/get_profile_stream_usecase.dart';

/// ✅ Public: لازم UID يكون موجود دائمًا
final publicProfileStreamProvider =
    StreamProvider.family<ProfileEntity?, String>((ref, uid) {
  final useCase = ref.watch(getProfileStreamUseCaseProvider);
  return useCase(uid);
});

/// ✅ Read-only دائماً
final publicCanEditProvider = Provider<bool>((ref) => false);

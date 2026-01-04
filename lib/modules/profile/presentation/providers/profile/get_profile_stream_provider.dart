import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/profile/domain/entities/profile_entity.dart';
import 'package:notes_tasks/modules/profile/domain/usecases/profile/get_profile_stream_usecase.dart';

final profileStreamProvider = StreamProvider<ProfileEntity?>((ref) {
  final useCase = ref.watch(getProfileStreamUseCaseProvider);
  return useCase();
});

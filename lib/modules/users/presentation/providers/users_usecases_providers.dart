import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_tasks/core/data/remote/firebase/providers/firebase_providers.dart';
import 'package:notes_tasks/core/services/users/users_service.dart';
import 'package:notes_tasks/modules/users/domain/usecases/get_users_stream_usecase.dart';

import '../../domain/usecases/set_user_role_usecase.dart';
import '../../domain/usecases/set_user_disabled_usecase.dart';

// final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final usersServiceProvider = Provider<UsersService>((ref) {
  return UsersService(ref.watch(firebaseFirestoreProvider));
});

final getUsersUseCaseProvider = Provider((ref) {
  return GetUsersUseCase(ref.watch(usersServiceProvider));
});

final setUserRoleUseCaseProvider = Provider((ref) {
  return SetUserRoleUseCase(ref.watch(usersServiceProvider));
});

final setUserDisabledUseCaseProvider = Provider((ref) {
  return SetUserDisabledUseCase(ref.watch(usersServiceProvider));
});

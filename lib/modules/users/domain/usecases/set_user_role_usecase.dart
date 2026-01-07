// lib/modules/users/domain/usecases/set_user_role_usecase.dart
import 'package:notes_tasks/core/services/users/users_service.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';

import '../entities/app_user_entity.dart';

class SetUserRoleUseCase {
  final UsersService _service;
  SetUserRoleUseCase(this._service);

  Future<void> call({required String userId, required UserRole role}) {
    return _service.setUserRole(userId: userId, role: role);
  }
}

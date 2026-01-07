// lib/modules/users/domain/usecases/get_users_usecase.dart
import 'package:notes_tasks/core/services/users/users_service.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';

import '../entities/app_user_entity.dart';
import '../../data/models/app_user_model.dart';

class GetUsersUseCase {
  final UsersService _service;
  GetUsersUseCase(this._service);

  Future<List<AppUserModel>> call({UserRole? role}) {
    return _service.getUsers(role: role);
  }
}

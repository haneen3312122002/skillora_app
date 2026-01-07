import 'package:notes_tasks/core/services/users/users_service.dart';

class SetUserDisabledUseCase {
  final UsersService _service;
  SetUserDisabledUseCase(this._service);

  Future<void> call({required String userId, required bool isDisabled}) {
    return _service.setUserDisabled(userId: userId, isDisabled: isDisabled);
  }
}

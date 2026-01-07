import 'package:notes_tasks/core/services/users/users_service.dart';

class DeleteUserDocUseCase {
  final UsersService _service;
  DeleteUserDocUseCase(this._service);

  Future<void> call(String userId) => _service.deleteUserDoc(userId);
}

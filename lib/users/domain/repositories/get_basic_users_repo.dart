import 'package:notes_tasks/users/domain/entities/user_entity.dart';

abstract class IGetBasicUsersRepo {
  Future<List<UserEntity>> getBasicUsers();
}

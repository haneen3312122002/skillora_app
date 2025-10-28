import 'package:notes_tasks/users/domain/entities/user_entity.dart';


abstract class IGetAuthUserRepo {
  Future<UserEntity> getAuthUser(String token);
}

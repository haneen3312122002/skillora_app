import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/auth/domain/repositories/get_auth_user_repo.dart';


class GetAuthUserUseCase {
  final IGetAuthUserRepo repo;

  GetAuthUserUseCase(this.repo);

  Future<UserEntity> call(String token) async {
    return await repo.getAuthUser(token);
  }
}

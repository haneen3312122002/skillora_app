import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/domain/repositories/get_basic_users_repo.dart';

class GetBasicUsersUseCase {
  final IGetBasicUsersRepo repo;

  GetBasicUsersUseCase(this.repo);

  Future<List<UserEntity>> call() async {
    return await repo.getBasicUsers();
  }
}

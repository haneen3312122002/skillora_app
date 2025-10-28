import 'package:notes_tasks/users/data/datasources/get_basic_users_remote_datasource.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/domain/repositories/get_basic_users_repo.dart';

class GetBasicUsersRepoImpl implements IGetBasicUsersRepo {
  final IGetBasicUsersRemoteDataSource dataSource;

  GetBasicUsersRepoImpl(this.dataSource);

  @override
  Future<List<UserEntity>> getBasicUsers() async {
    final models = await dataSource.getBasicUsers();
    return models.map((e) => e.toEntity()).toList();
  }
}

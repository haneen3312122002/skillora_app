import 'package:notes_tasks/auth/data/datasources/get_auth_user_datasource.dart';
import 'package:notes_tasks/auth/domain/repositories/get_auth_user_repo.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';

class GetAuthUserRepoImpl implements IGetAuthUserRepo {
  final IGetAuthUserDataSource dataSource;

  GetAuthUserRepoImpl(this.dataSource);

  @override
  Future<UserEntity> getAuthUser(String token) async {
    final userModel = await dataSource.getAuthUser(token);
    return userModel.toEntity();
  }
}

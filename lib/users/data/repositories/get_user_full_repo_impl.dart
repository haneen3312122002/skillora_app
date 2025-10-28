import 'package:notes_tasks/users/data/datasources/get_user_full_remote_datasource.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/domain/repositories/get_user_full_repo.dart';

class GetUserFullRepoImpl implements IGetUserFullRepo {
  final IGetUserFullRemoteDataSource dataSource;

  GetUserFullRepoImpl(this.dataSource);

  @override
  Future<UserEntity> getUserFull(int id) async {
    final model = await dataSource.getUserFull(id);
    return model.toEntity();
  }
}

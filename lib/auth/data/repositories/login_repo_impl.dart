import 'package:notes_tasks/auth/data/datasources/login_datasource.dart';
import 'package:notes_tasks/auth/domain/entities/auth_entity.dart';
import 'package:notes_tasks/auth/domain/repositories/login_repo.dart';

class LoginRepoImpl implements ILoginRepo {
  final ILoginDataSource dataSource;

  LoginRepoImpl(this.dataSource);

  @override
  Future<AuthEntity> login(String username, String password) async {
    final model = await dataSource.login(username, password);
    return model.toEntity();
  }
}

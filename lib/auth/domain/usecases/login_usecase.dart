import 'package:notes_tasks/auth/domain/entities/auth_entity.dart';
import 'package:notes_tasks/auth/domain/repositories/login_repo.dart';

class LoginUseCase {
  final ILoginRepo repo;

  LoginUseCase(this.repo);

  Future<AuthEntity> call(String username, String password) async {
    return await repo.login(username, password);
  }
}

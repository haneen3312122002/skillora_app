import 'package:notes_tasks/auth/api/login_api/i_login_api_service.dart';
import 'package:notes_tasks/auth/data/models/auth_model.dart';

abstract class ILoginDataSource {
  Future<AuthModel> login(String username, String password);
}

class LoginDataSource implements ILoginDataSource {
  final ILoginApiService api; 

  LoginDataSource(this.api);

  @override
  Future<AuthModel> login(String username, String password) async {
    return await api.login(username: username, password: password);
  }
}

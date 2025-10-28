import 'package:notes_tasks/auth/api/get_auth_user_api/i_get_auth_user_api_service.dart';
import 'package:notes_tasks/users/data/models/user_model.dart';

abstract class IGetAuthUserDataSource {
  Future<UserModel> getAuthUser(String token);
}

class GetAuthUserDataSource implements IGetAuthUserDataSource {
  final IGetAuthUserApiService api;

  GetAuthUserDataSource(this.api);

  @override
  Future<UserModel> getAuthUser(String token) async {
    return await api.getAuthUser(token);
  }
}

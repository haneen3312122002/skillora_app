import 'package:notes_tasks/core/constants/endpoints.dart';
import 'package:notes_tasks/core/services/api/api_service.dart';
import 'package:notes_tasks/modules/auth/data/models/auth_model.dart';
import 'i_login_api_service.dart';

class LoginApiService implements ILoginApiService {
  @override
  Future<AuthModel> login({
    required String username,
    required String password,
  }) async {
    final data = await ApiService.post(
      AppEndpoints.login,
      body: {'username': username, 'password': password, 'expiresInMins': 30},
    );
    return AuthModel.fromJson(data);
  }
}

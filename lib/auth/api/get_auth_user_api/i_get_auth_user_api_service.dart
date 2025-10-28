import 'package:notes_tasks/users/data/models/user_model.dart';

abstract class IGetAuthUserApiService {
  Future<UserModel> getAuthUser(String token);
}

import 'package:notes_tasks/users/api/get_basic_users_api/i_get_basic_users_api_service.dart';
import 'package:notes_tasks/users/data/models/user_model.dart';


abstract class IGetBasicUsersRemoteDataSource {
  Future<List<UserModel>> getBasicUsers();
}

class GetBasicUsersRemoteDataSource implements IGetBasicUsersRemoteDataSource {
  final IGetBasicUsersApiService api;

  GetBasicUsersRemoteDataSource(this.api);

  @override
  Future<List<UserModel>> getBasicUsers() async {
    final data = await api.getBasicUsers();
    return data.map((e) => UserModel.fromMap(e)).toList();
  }
}

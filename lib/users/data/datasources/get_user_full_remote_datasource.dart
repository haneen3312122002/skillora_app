import 'package:notes_tasks/users/api/get_user_full_api/i_get_user_full_api_service.dart';
import 'package:notes_tasks/users/data/models/user_model.dart';


abstract class IGetUserFullRemoteDataSource {
  Future<UserModel> getUserFull(int id);
}

class GetUserFullRemoteDataSource implements IGetUserFullRemoteDataSource {
  final IGetUserFullApiService api;

  GetUserFullRemoteDataSource(this.api);

  @override
  Future<UserModel> getUserFull(int id) async {
    final data = await api.getUserFull(id);
    return UserModel.fromMap(data);
  }
}

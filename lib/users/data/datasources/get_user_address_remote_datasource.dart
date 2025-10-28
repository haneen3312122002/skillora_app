import 'package:notes_tasks/users/api/get_user_address_api/i_get_user_address_api_service.dart';
import 'package:notes_tasks/users/data/models/user_model.dart';


abstract class IGetUserAddressRemoteDataSource {
  Future<AddressModel> getUserAddress(int id);
}

class GetUserAddressRemoteDataSource
    implements IGetUserAddressRemoteDataSource {
  final IGetUserAddressApiService api;

  GetUserAddressRemoteDataSource(this.api);

  @override
  Future<AddressModel> getUserAddress(int id) async {
    final data = await api.getUserAddress(id);
    return AddressModel.fromMap(data);
  }
}

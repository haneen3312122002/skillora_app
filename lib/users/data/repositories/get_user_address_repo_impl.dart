import 'package:notes_tasks/users/data/datasources/get_user_address_remote_datasource.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/domain/repositories/get_user_address_repo.dart';

class GetUserAddressRepoImpl implements IGetUserAddressRepo {
  final IGetUserAddressRemoteDataSource dataSource;

  GetUserAddressRepoImpl(this.dataSource);

  @override
  Future<AddressEntity> getUserAddress(int id) async {
    final model = await dataSource.getUserAddress(id);
    return model.toEntity();
  }
}

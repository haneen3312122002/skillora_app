import 'package:notes_tasks/users/data/datasources/get_user_bank_remote_datasource.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/domain/repositories/get_user_bank_repo.dart';

class GetUserBankRepoImpl implements IGetUserBankRepo {
  final IGetUserBankRemoteDataSource dataSource;

  GetUserBankRepoImpl(this.dataSource);

  @override
  Future<BankEntity> getUserBank(int id) async {
    final model = await dataSource.getUserBank(id);
    return model.toEntity();
  }
}

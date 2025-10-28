import 'package:notes_tasks/users/api/get_user_bank_api/i_get_user_bank_api_service.dart';
import 'package:notes_tasks/users/data/models/user_model.dart';


abstract class IGetUserBankRemoteDataSource {
  Future<BankModel> getUserBank(int id);
}

class GetUserBankRemoteDataSource implements IGetUserBankRemoteDataSource {
  final IGetUserBankApiService api;

  GetUserBankRemoteDataSource(this.api);

  @override
  Future<BankModel> getUserBank(int id) async {
    final data = await api.getUserBank(id);
    return BankModel.fromMap(data);
  }
}

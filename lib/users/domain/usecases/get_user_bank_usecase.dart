import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/domain/repositories/get_user_bank_repo.dart';

class GetUserBankUseCase {
  final IGetUserBankRepo repo;

  GetUserBankUseCase(this.repo);

  Future<BankEntity> call(int id) async {
    return await repo.getUserBank(id);
  }
}

import 'package:notes_tasks/users/domain/entities/user_entity.dart';

abstract class IGetUserBankRepo {
  Future<BankEntity> getUserBank(int id);
}

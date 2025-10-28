import 'package:notes_tasks/users/domain/entities/user_entity.dart';

abstract class IGetUserCompanyRepo {
  Future<CompanyEntity> getUserCompany(int id);
}

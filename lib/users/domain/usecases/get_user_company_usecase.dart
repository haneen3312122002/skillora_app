import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/domain/repositories/get_user_company_repo.dart';

class GetUserCompanyUseCase {
  final IGetUserCompanyRepo repo;

  GetUserCompanyUseCase(this.repo);

  Future<CompanyEntity> call(int id) async {
    return await repo.getUserCompany(id);
  }
}

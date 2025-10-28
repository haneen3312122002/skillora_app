import 'package:notes_tasks/users/data/datasources/get_user_company_remote_datasource.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/domain/repositories/get_user_company_repo.dart';

class GetUserCompanyRepoImpl implements IGetUserCompanyRepo {
  final IGetUserCompanyRemoteDataSource dataSource;

  GetUserCompanyRepoImpl(this.dataSource);

  @override
  Future<CompanyEntity> getUserCompany(int id) async {
    final model = await dataSource.getUserCompany(id);
    return model.toEntity();
  }
}

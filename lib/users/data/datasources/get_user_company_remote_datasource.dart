import 'package:notes_tasks/users/api/get_user_company_api/i_get_user_company_api_service.dart';
import 'package:notes_tasks/users/data/models/user_model.dart';


abstract class IGetUserCompanyRemoteDataSource {
  Future<CompanyModel> getUserCompany(int id);
}

class GetUserCompanyRemoteDataSource
    implements IGetUserCompanyRemoteDataSource {
  final IGetUserCompanyApiService api;

  GetUserCompanyRemoteDataSource(this.api);

  @override
  Future<CompanyModel> getUserCompany(int id) async {
    final data = await api.getUserCompany(id);
    return CompanyModel.fromMap(data);
  }
}

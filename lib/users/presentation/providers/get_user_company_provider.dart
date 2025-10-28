import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/users/api/get_user_company_api/get_user_company_api_service.dart';
import 'package:notes_tasks/users/data/datasources/get_user_company_remote_datasource.dart';
import 'package:notes_tasks/users/data/repositories/get_user_company_repo_impl.dart';
import 'package:notes_tasks/users/domain/repositories/get_user_company_repo.dart';
import 'package:notes_tasks/users/domain/usecases/get_user_company_usecase.dart';

final getUserCompanyApiProvider = Provider<GetUserCompanyApiService>((ref) {
  return GetUserCompanyApiService();
});

final getUserCompanyDataSourceProvider =
    Provider<IGetUserCompanyRemoteDataSource>((ref) {
      final api = ref.watch(getUserCompanyApiProvider);
      return GetUserCompanyRemoteDataSource(api);
    });

final getUserCompanyRepoProvider = Provider<IGetUserCompanyRepo>((ref) {
  final ds = ref.watch(getUserCompanyDataSourceProvider);
  return GetUserCompanyRepoImpl(ds);
});

final getUserCompanyUseCaseProvider = Provider<GetUserCompanyUseCase>((ref) {
  final repo = ref.watch(getUserCompanyRepoProvider);
  return GetUserCompanyUseCase(repo);
});

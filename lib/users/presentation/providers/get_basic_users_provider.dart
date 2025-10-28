import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/users/data/datasources/get_basic_users_remote_datasource.dart';
import 'package:notes_tasks/users/data/repositories/get_basic_users_repo_impl.dart';
import 'package:notes_tasks/users/domain/repositories/get_basic_users_repo.dart';
import 'package:notes_tasks/users/domain/usecases/get_basic_users_usecase.dart';
import 'package:notes_tasks/users/api/get_basic_users_api/get_basic_users_api_service.dart';


final getBasicUsersApiProvider = Provider<GetBasicUsersApiService>((ref) {
  return GetBasicUsersApiService();
});


final getBasicUsersDataSourceProvider =
    Provider<IGetBasicUsersRemoteDataSource>((ref) {
      final api = ref.watch(getBasicUsersApiProvider);
      return GetBasicUsersRemoteDataSource(api);
    });


final getBasicUsersRepoProvider = Provider<IGetBasicUsersRepo>((ref) {
  final ds = ref.watch(getBasicUsersDataSourceProvider);
  return GetBasicUsersRepoImpl(ds);
});


final getBasicUsersUseCaseProvider = Provider<GetBasicUsersUseCase>((ref) {
  final repo = ref.watch(getBasicUsersRepoProvider);
  return GetBasicUsersUseCase(repo);
});

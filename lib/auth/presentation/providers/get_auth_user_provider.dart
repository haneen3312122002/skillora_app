import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/auth/api/get_auth_user_api/get_auth_user_api_service.dart';
import 'package:notes_tasks/auth/data/datasources/get_auth_user_datasource.dart';
import 'package:notes_tasks/auth/data/repositories/get_auth_user_repo_impl.dart';
import 'package:notes_tasks/auth/domain/repositories/get_auth_user_repo.dart';
import 'package:notes_tasks/auth/domain/usecases/get_auth_user_usecase.dart';

final getAuthUserApiServiceProvider = Provider<GetAuthUserApiService>((ref) {
  return GetAuthUserApiService();
});

final getAuthUserDataSourceProvider = Provider<IGetAuthUserDataSource>((ref) {
  final api = ref.watch(getAuthUserApiServiceProvider);
  return GetAuthUserDataSource(api);
});

final getAuthUserRepoProvider = Provider<IGetAuthUserRepo>((ref) {
  final ds = ref.watch(getAuthUserDataSourceProvider);
  return GetAuthUserRepoImpl(ds);
});

final getAuthUserUseCaseProvider = Provider<GetAuthUserUseCase>((ref) {
  final repo = ref.watch(getAuthUserRepoProvider);
  return GetAuthUserUseCase(repo);
});

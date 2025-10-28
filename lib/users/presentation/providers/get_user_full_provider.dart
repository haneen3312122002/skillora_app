import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/users/api/get_user_full_api/get_user_full_api_service.dart';
import 'package:notes_tasks/users/data/datasources/get_user_full_remote_datasource.dart';
import 'package:notes_tasks/users/data/repositories/get_user_full_repo_impl.dart';
import 'package:notes_tasks/users/domain/repositories/get_user_full_repo.dart';
import 'package:notes_tasks/users/domain/usecases/get_user_full_usecase.dart';

final getUserFullApiProvider = Provider<GetUserFullApiService>((ref) {
  return GetUserFullApiService();
});

final getUserFullDataSourceProvider = Provider<IGetUserFullRemoteDataSource>((
  ref,
) {
  final api = ref.watch(getUserFullApiProvider);
  return GetUserFullRemoteDataSource(api);
});

final getUserFullRepoProvider = Provider<IGetUserFullRepo>((ref) {
  final ds = ref.watch(getUserFullDataSourceProvider);
  return GetUserFullRepoImpl(ds);
});

final getUserFullUseCaseProvider = Provider<GetUserFullUseCase>((ref) {
  final repo = ref.watch(getUserFullRepoProvider);
  return GetUserFullUseCase(repo);
});

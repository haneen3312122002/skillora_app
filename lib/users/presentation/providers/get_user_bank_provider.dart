import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/users/api/get_user_bank_api/get_user_bank_api_service.dart';
import 'package:notes_tasks/users/data/datasources/get_user_bank_remote_datasource.dart';
import 'package:notes_tasks/users/data/repositories/get_user_bank_repo_impl.dart';
import 'package:notes_tasks/users/domain/repositories/get_user_bank_repo.dart';
import 'package:notes_tasks/users/domain/usecases/get_user_bank_usecase.dart';

final getUserBankApiProvider = Provider<GetUserBankApiService>((ref) {
  return GetUserBankApiService();
});

final getUserBankDataSourceProvider = Provider<IGetUserBankRemoteDataSource>((
  ref,
) {
  final api = ref.watch(getUserBankApiProvider);
  return GetUserBankRemoteDataSource(api);
});

final getUserBankRepoProvider = Provider<IGetUserBankRepo>((ref) {
  final ds = ref.watch(getUserBankDataSourceProvider);
  return GetUserBankRepoImpl(ds);
});

final getUserBankUseCaseProvider = Provider<GetUserBankUseCase>((ref) {
  final repo = ref.watch(getUserBankRepoProvider);
  return GetUserBankUseCase(repo);
});

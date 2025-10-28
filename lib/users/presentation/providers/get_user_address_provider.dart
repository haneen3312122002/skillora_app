import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/users/api/get_user_address_api/get_user_address_api_service.dart';
import 'package:notes_tasks/users/data/datasources/get_user_address_remote_datasource.dart';
import 'package:notes_tasks/users/data/repositories/get_user_address_repo_impl.dart';
import 'package:notes_tasks/users/domain/repositories/get_user_address_repo.dart';
import 'package:notes_tasks/users/domain/usecases/get_user_address_usecase.dart';

final getUserAddressApiProvider = Provider<GetUserAddressApiService>((ref) {
  return GetUserAddressApiService();
});

final getUserAddressDataSourceProvider =
    Provider<IGetUserAddressRemoteDataSource>((ref) {
      final api = ref.watch(getUserAddressApiProvider);
      return GetUserAddressRemoteDataSource(api);
    });

final getUserAddressRepoProvider = Provider<IGetUserAddressRepo>((ref) {
  final ds = ref.watch(getUserAddressDataSourceProvider);
  return GetUserAddressRepoImpl(ds);
});

final getUserAddressUseCaseProvider = Provider<GetUserAddressUseCase>((ref) {
  final repo = ref.watch(getUserAddressRepoProvider);
  return GetUserAddressUseCase(repo);
});

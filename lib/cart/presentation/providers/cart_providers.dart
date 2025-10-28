import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/cart/api/get_first_cart_api/get_first_cart_api_service.dart';
import 'package:notes_tasks/cart/api/get_first_cart_api/i_get_first_cart_api_service.dart';
import 'package:notes_tasks/cart/data/datasources/get_first_cart_remote_datasource.dart';
import 'package:notes_tasks/cart/data/repositories/get_first_cart_repo_impl.dart';
import 'package:notes_tasks/cart/domain/repositories/get_first_cart_repo.dart';
import 'package:notes_tasks/cart/domain/usecases/get_first_cart_usecase.dart';

final getFirstCartApiServiceProvider = Provider<IGetFirstCartApiService>((ref) {
  return GetFirstCartApiService();
});

final getFirstCartDataSourceProvider = Provider<IGetFirstCartRemoteDataSource>((
  ref,
) {
  final api = ref.read(getFirstCartApiServiceProvider);
  return GetFirstCartRemoteDataSource(api);
});

final getFirstCartRepoProvider = Provider<IGetFirstCartRepo>((ref) {
  final ds = ref.read(getFirstCartDataSourceProvider);
  return GetFirstCartRepoImpl(ds);
});

final getFirstCartUseCaseProvider = Provider<GetFirstCartUseCase>((ref) {
  final repo = ref.read(getFirstCartRepoProvider);
  return GetFirstCartUseCase(repo);
});

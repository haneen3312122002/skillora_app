import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/auth/api/login_api/login_api_service.dart';
import 'package:notes_tasks/auth/data/datasources/login_datasource.dart';
import 'package:notes_tasks/auth/data/repositories/login_repo_impl.dart';
import 'package:notes_tasks/auth/domain/repositories/login_repo.dart';
import 'package:notes_tasks/auth/domain/usecases/login_usecase.dart';

final loginApiServiceProvider = Provider<LoginApiService>((ref) {
  return LoginApiService();
});

final loginDataSourceProvider = Provider<ILoginDataSource>((ref) {
  final api = ref.watch(loginApiServiceProvider);
  return LoginDataSource(api);
});

final loginRepoProvider = Provider<ILoginRepo>((ref) {
  final ds = ref.watch(loginDataSourceProvider);
  return LoginRepoImpl(ds);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.watch(loginRepoProvider);
  return LoginUseCase(repo);
});

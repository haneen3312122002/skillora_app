import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/auth/api/Refresh_Token_API/refresh_token_api_service.dart';
import 'package:notes_tasks/auth/data/datasources/refresh_token_datasource.dart';
import 'package:notes_tasks/auth/data/repositories/refresh_token_repo_impl.dart';
import 'package:notes_tasks/auth/domain/repositories/refresh_token_repo.dart';
import 'package:notes_tasks/auth/domain/usecases/refresh_token_usecase.dart';

final refreshTokenApiServiceProvider = Provider<RefreshTokenApiService>((ref) {
  return RefreshTokenApiService();
});

final refreshTokenDataSourceProvider = Provider<IRefreshTokenDataSource>((ref) {
  final api = ref.watch(refreshTokenApiServiceProvider);
  return RefreshTokenDataSource(api);
});

final refreshTokenRepoProvider = Provider<IRefreshTokenRepo>((ref) {
  final ds = ref.watch(refreshTokenDataSourceProvider);
  return RefreshTokenRepoImpl(ds);
});

final refreshTokenUseCaseProvider = Provider<RefreshTokenUseCase>((ref) {
  final repo = ref.watch(refreshTokenRepoProvider);
  return RefreshTokenUseCase(repo);
});

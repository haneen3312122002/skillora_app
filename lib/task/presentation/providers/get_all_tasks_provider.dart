import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/task/api/get_all_tasks_api/get_all_tasks_api_service.dart';
import 'package:notes_tasks/task/api/get_all_tasks_api/i_get_all_tasks_api_service.dart';
import 'package:notes_tasks/task/data/datasources/get_all_tasks_remote_datasource.dart';
import 'package:notes_tasks/task/data/repositories/get_all_tasks_repo_impl.dart';
import 'package:notes_tasks/task/domain/repositories/get_all_tasks_repo.dart';
import 'package:notes_tasks/task/domain/usecases/get_all_tasks_usecase.dart';

final getAllTasksApiServiceProvider = Provider<IGetAllTasksApiService>((ref) {
  return GetAllTasksApiService();
});

final getAllTasksDataSourceProvider = Provider<IGetAllTasksRemoteDataSource>((
  ref,
) {
  final api = ref.read(getAllTasksApiServiceProvider);
  return GetAllTasksRemoteDataSource(api);
});

final getAllTasksRepoProvider = Provider<IGetAllTasksRepo>((ref) {
  final ds = ref.read(getAllTasksDataSourceProvider);
  return GetAllTasksRepoImpl(ds);
});

final getAllTasksUseCaseProvider = Provider<GetAllTasksUseCase>((ref) {
  final repo = ref.read(getAllTasksRepoProvider);
  return GetAllTasksUseCase(repo);
});

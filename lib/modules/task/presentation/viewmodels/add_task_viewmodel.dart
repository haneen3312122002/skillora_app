import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/modules/task/domain/entities/task_entity.dart';
import 'package:notes_tasks/modules/task/domain/usecases/add_task_usecase.dart';
import 'package:notes_tasks/modules/task/presentation/providers/add_task_provider.dart';

final _addTaskViewModelProvider =
    AsyncNotifierProvider<_AddTaskViewModel, TaskEntity?>(
        _AddTaskViewModel.new);

class _AddTaskViewModel extends AsyncNotifier<TaskEntity?> {
  late final AddTaskUseCase _addTaskUseCase = ref.read(addTaskUseCaseProvider);

  @override
  FutureOr<TaskEntity?> build() async => null;

  Future<void> addTask({
    required String todo,
    required bool completed,
    required int userId,
  }) async {
    state = const AsyncLoading();
    try {
      final task = await _addTaskUseCase(
        todo: todo,
        completed: completed,
        userId: userId,
      );
      state = AsyncData(task);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

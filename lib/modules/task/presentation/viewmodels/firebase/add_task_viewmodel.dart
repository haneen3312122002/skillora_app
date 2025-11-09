import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/core/providers/firebase/tasks/task_service_provider.dart';

final addTaskViewModelProvider =
    AsyncNotifierProvider<AddTaskViewModel, String?>(AddTaskViewModel.new);

class AddTaskViewModel extends AsyncNotifier<String?> {
  @override
  FutureOr<String?> build() async => null;

  Future<void> submit(BuildContext context, {required String rawTitle}) async {
    if (state.isLoading) return;
    final title = rawTitle.trim();
    if (title.isEmpty) {
      _snack(context, 'Please enter a task title');
      return;
    }
    FocusScope.of(context).unfocus();

    state = const AsyncLoading();
    try {
      final svc = ref.read(TaskServiceProvider);
      final id = await svc.addTask(title: title);
      state = AsyncData(id);
      _snack(context, 'Task added');
      Navigator.pop(context);
    } catch (e, st) {
      state = AsyncError(e, st);
      _snack(context, 'Failed: $e');
    }
  }

  void _snack(BuildContext c, String m) =>
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(m)));
}

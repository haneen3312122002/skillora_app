import 'package:notes_tasks/task/domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.todo,
    required super.completed,
    required super.userId,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? 0,
      todo: map['todo'] ?? '',
      completed: map['completed'] ?? false,
      userId: map['userId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'todo': todo,
    'completed': completed,
    'userId': userId,
  };

  TaskEntity toEntity() => this;
}

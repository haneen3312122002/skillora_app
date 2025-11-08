class TaskEntity {
  final String id;
  final String todo;
  final bool completed;
  final String userId;

  const TaskEntity({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });
}

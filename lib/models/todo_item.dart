enum Priority { low, medium, high }

enum TodoStatus { pending, inProgress, review, completed }

class TodoItem {
  final String id;
  String title;
  String? description;
  DateTime? dueDate;
  Priority priority;
  TodoStatus status;
  bool isDone;

  TodoItem({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.priority = Priority.medium,
    this.status = TodoStatus.pending,
    this.isDone = false,
  });
}

import 'package:objectbox/objectbox.dart';

enum Priority { low, medium, high }

enum TodoStatus { pending, inProgress, review, completed }

@Entity()
class TodoItem {
  @Id()
  int? dbId;
  
  @Unique()
  final String id;
  
  String title;
  String? description;
  @Property(type: PropertyType.dateUtc)
  DateTime? dueDate;
  
  int priorityValue; // Stored as int in database
  int statusValue;   // Stored as int in database
  bool isDone;

  // Helper properties to work with enums
  Priority get priority => Priority.values[priorityValue];
  set priority(Priority value) => priorityValue = value.index;
  
  TodoStatus get status => TodoStatus.values[statusValue];
  set status(TodoStatus value) => statusValue = value.index;

  TodoItem({
    this.dbId,
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    Priority priority = Priority.medium,
    TodoStatus status = TodoStatus.pending,
    this.isDone = false,
  })  : priorityValue = priority.index,
        statusValue = status.index;
}

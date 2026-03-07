import '../../objectbox.g.dart';
import '../../models/todo_item.dart';

/// Repository for managing TodoItem data persistence
class TodoRepository {
  final Box<TodoItem> _todoBox;

  TodoRepository(this._todoBox);

  /// Get all todos
  List<TodoItem> getAllTodos() {
    return _todoBox.getAll();
  }

  /// Get a single todo by ID
  TodoItem? getTodoById(String id) {
    final query = _todoBox.query(TodoItem_.id.equals(id)).build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  /// Add a new todo
  void addTodo(TodoItem todo) {
    _todoBox.put(todo);
  }

  /// Update an existing todo
  void updateTodo(TodoItem todo) {
    _todoBox.put(todo);
  }

  /// Delete a todo
  void deleteTodo(String id) {
    final query = _todoBox.query(TodoItem_.id.equals(id)).build();
    query.remove();
    query.close();
  }

  /// Get todos by status
  List<TodoItem> getTodosByStatus(int statusValue) {
    final query = _todoBox.query(TodoItem_.statusValue.equals(statusValue)).build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Get todos by priority
  List<TodoItem> getTodosByPriority(int priorityValue) {
    final query = _todoBox.query(TodoItem_.priorityValue.equals(priorityValue)).build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Get todos for a specific date
  List<TodoItem> getTodosForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = _todoBox
        .query(TodoItem_.dueDate.betweenDate(startOfDay, endOfDay))
        .build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Get completed todos
  List<TodoItem> getCompletedTodos() {
    final query = _todoBox.query(TodoItem_.isDone.equals(true)).build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Get pending todos
  List<TodoItem> getPendingTodos() {
    final query = _todoBox.query(TodoItem_.isDone.equals(false)).build();
    final results = query.find();
    query.close();
    return results;
  }

  /// Get count of todos by status
  Map<int, int> countByStatus() {
    final allTodos = getAllTodos();
    final counts = <int, int>{};
    for (final todo in allTodos) {
      counts[todo.statusValue] = (counts[todo.statusValue] ?? 0) + 1;
    }
    return counts;
  }

  /// Clear all todos
  void clearAll() {
    _todoBox.removeAll();
  }
}


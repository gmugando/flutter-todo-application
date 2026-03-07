import '../../models/todo_item.dart';

/// In-memory repository implementation for platforms without ObjectBox support (e.g., web)
class InMemoryTodoRepository {
  final List<TodoItem> _todos = [];

  /// Get all todos
  List<TodoItem> getAllTodos() {
    return List.from(_todos);
  }

  /// Get a single todo by ID
  TodoItem? getTodoById(String id) {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a new todo
  void addTodo(TodoItem todo) {
    _todos.add(todo);
  }

  /// Update an existing todo
  void updateTodo(TodoItem todo) {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
    }
  }

  /// Delete a todo
  void deleteTodo(String id) {
    _todos.removeWhere((t) => t.id == id);
  }

  /// Get todos by status
  List<TodoItem> getTodosByStatus(int statusValue) {
    return _todos.where((t) => t.statusValue == statusValue).toList();
  }

  /// Get todos by priority
  List<TodoItem> getTodosByPriority(int priorityValue) {
    return _todos.where((t) => t.priorityValue == priorityValue).toList();
  }

  /// Get todos for a specific date
  List<TodoItem> getTodosForDate(DateTime date) {
    return _todos.where((t) {
      final dueDate = t.dueDate;
      if (dueDate == null) return false;
      return dueDate.year == date.year &&
          dueDate.month == date.month &&
          dueDate.day == date.day;
    }).toList();
  }

  /// Get completed todos
  List<TodoItem> getCompletedTodos() {
    return _todos.where((t) => t.isDone).toList();
  }

  /// Get pending todos
  List<TodoItem> getPendingTodos() {
    return _todos.where((t) => !t.isDone).toList();
  }

  /// Get count of todos by status
  Map<int, int> countByStatus() {
    final counts = <int, int>{};
    for (final todo in _todos) {
      counts[todo.statusValue] = (counts[todo.statusValue] ?? 0) + 1;
    }
    return counts;
  }

  /// Clear all todos
  void clearAll() {
    _todos.clear();
  }
}

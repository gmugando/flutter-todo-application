import '../../models/todo_item.dart';

/// Base interface for todo repositories
abstract class IOrderedRepository {
  List<TodoItem> getAllTodos();
  TodoItem? getTodoById(String id);
  void addTodo(TodoItem todo);
  void updateTodo(TodoItem todo);
  void deleteTodo(String id);
  List<TodoItem> getTodosByStatus(int statusValue);
  List<TodoItem> getTodosByPriority(int priorityValue);
  List<TodoItem> getTodosForDate(DateTime date);
  List<TodoItem> getCompletedTodos();
  List<TodoItem> getPendingTodos();
  Map<int, int> countByStatus();
  void clearAll();
}

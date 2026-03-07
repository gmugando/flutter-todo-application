import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class TodoViewmodel extends ChangeNotifier {
  final dynamic _repository; // Can be TodoRepository or InMemoryTodoRepository

  TodoViewmodel(this._repository);

  List<TodoItem> get tasks => _repository.getAllTodos();

  /// Add a new task and persist it
  void addTask(TodoItem task) {
    if (task.title.trim().isEmpty) return;
    _repository.addTodo(task);
    notifyListeners();
  }

  /// Update an existing task
  void updateTask(TodoItem updated) {
    final existing = _repository.getTodoById(updated.id);
    if (existing != null) {
      _repository.updateTodo(updated);
      notifyListeners();
    }
  }

  /// Toggle task completion status
  void toggleCompletion(String id) {
    final task = _repository.getTodoById(id);
    if (task != null) {
      task.isDone = !task.isDone;
      _repository.updateTodo(task);
      notifyListeners();
    }
  }

  /// Delete a task
  void deleteTask(String id) {
    _repository.deleteTodo(id);
    notifyListeners();
  }

  /// Get tasks for a specific date
  List<TodoItem> tasksForDate(DateTime date) {
    return _repository.getTodosForDate(date);
  }

  /// Get count of tasks by status
  Map<TodoStatus, int> countByStatus() {
    final counts = <TodoStatus, int>{};
    for (var status in TodoStatus.values) {
      counts[status] = 0;
    }
    final statusCounts = _repository.countByStatus();
    for (var statusValue in statusCounts.keys) {
      final status = TodoStatus.values[statusValue];
      counts[status] = statusCounts[statusValue] ?? 0;
    }
    return counts;
  }

  /// Get tasks by status
  List<TodoItem> tasksByStatus(TodoStatus status) {
    return _repository.getTodosByStatus(status.index);
  }

  /// Get completed tasks
  List<TodoItem> getCompletedTasks() {
    return _repository.getCompletedTodos();
  }

  /// Get pending tasks
  List<TodoItem> getPendingTasks() {
    return _repository.getPendingTodos();
  }
}
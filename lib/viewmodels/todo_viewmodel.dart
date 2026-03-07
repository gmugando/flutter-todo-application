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

  /// Get top N tasks sorted by priority and status
  List<TodoItem> getTopTasks({int limit = 3}) {
    final allTasks = tasks;
    
    // Sort by status priority (pending > inProgress > review > completed)
    // Then by priority (high > medium > low)
    allTasks.sort((a, b) {
      // First sort by status (active tasks first)
      final statusOrder = {
        TodoStatus.pending: 0,
        TodoStatus.inProgress: 1,
        TodoStatus.review: 2,
        TodoStatus.completed: 3,
      };
      final statusCompare = (statusOrder[a.status] ?? 3).compareTo(statusOrder[b.status] ?? 3);
      if (statusCompare != 0) return statusCompare;
      
      // Then sort by priority (high > medium > low)
      final priorityOrder = {Priority.high: 0, Priority.medium: 1, Priority.low: 2};
      return (priorityOrder[a.priority] ?? 2).compareTo(priorityOrder[b.priority] ?? 2);
    });
    
    return allTasks.take(limit).toList();
  }

  /// Get all tasks with due dates sorted by due date
  List<TodoItem> getTasksSortedByDueDate() {
    final allTasks = tasks.where((t) => t.dueDate != null).toList();
    allTasks.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    return allTasks;
  }
}
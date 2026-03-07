import 'package:flutter/material.dart';
import '../models/todo_item.dart';

class TodoViewmodel extends ChangeNotifier {
  final List<TodoItem> _tasks = [];

  List<TodoItem> get tasks => List.unmodifiable(_tasks);

  // create a copy with unique id using uuid externally
  void addTask(TodoItem task) {
    if (task.title.trim().isEmpty) return;
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(TodoItem updated) {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }

  void toggleCompletion(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isDone = !_tasks[index].isDone;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // Filtering helpers
  List<TodoItem> tasksForDate(DateTime date) {
    return _tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == date.year &&
          t.dueDate!.month == date.month &&
          t.dueDate!.day == date.day;
    }).toList();
  }

  Map<TodoStatus, int> countByStatus() {
    final counts = <TodoStatus, int>{};
    for (var status in TodoStatus.values) {
      counts[status] = 0;
    }
    for (var t in _tasks) {
      counts[t.status] = (counts[t.status] ?? 0) + 1;
    }
    return counts;
  }

  List<TodoItem> tasksByStatus(TodoStatus status) {
    return _tasks.where((t) => t.status == status).toList();
  }
}
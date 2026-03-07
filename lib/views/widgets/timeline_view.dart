import 'package:flutter/material.dart';

import '../../models/todo_item.dart';
import 'task_card.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({
    super.key,
    required this.tasks,
    required this.selectedDate,
    required this.onEditTask,
    required this.onDeleteTask,
  });

  final List<TodoItem> tasks;
  final DateTime selectedDate;
  final VoidCallback onEditTask;
  final Function(String) onDeleteTask;

  /// Generate hourly time slots (8 AM to 8 PM)
  List<DateTime> _generateTimeSlots() {
    final slots = <DateTime>[];
    for (int hour = 8; hour <= 20; hour++) {
      slots.add(DateTime(selectedDate.year, selectedDate.month, selectedDate.day, hour));
    }
    return slots;
  }

  /// Format time as "HH:MM AM/PM"
  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Get tasks for a specific hour slot
  List<TodoItem> _getTasksForSlot(DateTime slotTime) {
    return tasks.where((task) {
      final dueDate = task.dueDate;
      if (dueDate == null) return false;
      return dueDate.year == slotTime.year &&
          dueDate.month == slotTime.month &&
          dueDate.day == slotTime.day &&
          dueDate.hour == slotTime.hour;
    }).toList();
  }

  /// Get all-day tasks (tasks without specific time)
  List<TodoItem> _getAllDayTasks() {
    return tasks.where((task) {
      final dueDate = task.dueDate;
      if (dueDate == null) return false;
      // All-day tasks can be identified by checking if they have a specific hour
      // For now, we consider tasks without a specific hour as all-day
      return dueDate.year == selectedDate.year &&
          dueDate.month == selectedDate.month &&
          dueDate.day == selectedDate.day &&
          dueDate.hour == 0;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = _generateTimeSlots();
    final allDayTasks = _getAllDayTasks();
    
    // Check if there are any tasks for this date
    final hasTasksOnDate = tasks.any((task) {
      final dueDate = task.dueDate;
      if (dueDate == null) return false;
      return dueDate.year == selectedDate.year &&
          dueDate.month == selectedDate.month &&
          dueDate.day == selectedDate.day;
    });

    if (!hasTasksOnDate) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks scheduled for this date',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // All-day tasks section
        if (allDayTasks.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'All Day',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7D7D7D),
                  ),
                ),
                const SizedBox(height: 8),
                ...allDayTasks.map((task) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TaskCard(
                    task: task,
                    onEdit: onEditTask,
                    onDelete: () => onDeleteTask(task.id),
                  ),
                )),
              ],
            ),
          ),
        
        // Time slots with tasks
        ...timeSlots.map((slot) {
          final slotTasks = _getTasksForSlot(slot);
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatTime(slot),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7D7D7D),
                  ),
                ),
                const SizedBox(height: 8),
                if (slotTasks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No tasks',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                else
                  ...slotTasks.map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TaskCard(
                      task: task,
                      onEdit: onEditTask,
                      onDelete: () => onDeleteTask(task.id),
                    ),
                  )),
              ],
            ),
          );
        }),
      ],
    );
  }
}

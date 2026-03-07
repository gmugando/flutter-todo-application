import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/todo_item.dart';
import '../viewmodels/todo_viewmodel.dart';
import 'add_edit_task_screen.dart';
import 'widgets/timeline_view.dart';

class TaskScheduleScreen extends StatefulWidget {
  const TaskScheduleScreen({super.key});

  @override
  State<TaskScheduleScreen> createState() => _TaskScheduleScreenState();
}

class _TaskScheduleScreenState extends State<TaskScheduleScreen> {
  late DateTime _selectedDate;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F4F4),
        foregroundColor: const Color(0xFF1B1C1F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Task schedule',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Calendar widget
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TableCalendar<TodoItem>(
              firstDay: DateTime(2024, 1, 1),
              lastDay: DateTime(2026, 12, 31),
              focusedDay: _selectedDate,
              currentDay: DateTime.now(),
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
              onDaySelected: _onDaySelected,
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: const Color(0xFFC7DA75),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: const Color(0xFFC7DA75).withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: const TextStyle(
                  color: Color(0xFF1B1C1F),
                ),
                weekendTextStyle: const TextStyle(
                  color: Color(0xFF1B1C1F),
                ),
                outsideTextStyle: const TextStyle(
                  color: Color(0xFFB0B0B0),
                ),
                disabledTextStyle: const TextStyle(
                  color: Color(0xFFB0B0B0),
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B1C1F),
                ),
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: Color(0xFF1B1C1F),
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF1B1C1F),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          
          // Timeline view
          Expanded(
            child: Consumer<TodoViewmodel>(
              builder: (context, vm, _) {
                final tasksForDate = vm.tasksForDate(_selectedDate);
                
                return TimelineView(
                  tasks: tasksForDate,
                  selectedDate: _selectedDate,
                  onEditTask: () {
                    // TODO: Implement edit task
                  },
                  onDeleteTask: (id) {
                    vm.deleteTask(id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task deleted'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF27282C),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddEditTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

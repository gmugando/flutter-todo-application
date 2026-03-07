import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/todo_item.dart';
import '../viewmodels/todo_viewmodel.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TodoViewmodel>();
    final tasksForDay = _selectedDay != null
        ? vm.tasksForDate(_selectedDay!)
        : <TodoItem>[];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFE5E5E5),
                    child: Icon(Icons.person, color: Color(0xFF7D7D7D)),
                  ),
                  const Spacer(),
                  _CircleAction(
                    icon: Icons.add,
                    background: const Color(0xFF27282C),
                    iconColor: Colors.white,
                    onTap: () {},
                  ),
                  const SizedBox(width: 10),
                  _CircleAction(
                    icon: Icons.notifications_none_outlined,
                    background: const Color(0xFFE7E4F3),
                    iconColor: const Color(0xFF2A2A2A),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Task schedule',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.7,
                    height: 1.05,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          _selectedDay == null
                              ? '--/--/----'
                              : _dateLabel(_selectedDay!),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _CircleAction(
                    icon: Icons.edit_outlined,
                    background: const Color(0xFF27282C),
                    iconColor: Colors.white,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TableCalendar<TodoItem>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                },
                headerVisible: false,
                availableGestures: AvailableGestures.horizontalSwipe,
                calendarFormat: CalendarFormat.month,
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF35363A),
                  ),
                  weekendStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF35363A),
                  ),
                ),
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  defaultDecoration: const BoxDecoration(
                    color: Color(0xFFE8E8E8),
                    shape: BoxShape.circle,
                  ),
                  weekendDecoration: const BoxDecoration(
                    color: Color(0xFFE8E8E8),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: const BoxDecoration(
                    color: Color(0xFFC7DA75),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFF27282C),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  todayTextStyle: const TextStyle(
                    color: Color(0xFF1C1D21),
                    fontWeight: FontWeight.w700,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Color(0xFFB2A8DF),
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 1,
                  cellMargin: const EdgeInsets.all(4),
                ),
                eventLoader: (day) => vm.tasksForDate(day),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: tasksForDay.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks on this day',
                        style: TextStyle(color: Color(0xFF66676A)),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: tasksForDay.length,
                      itemBuilder: (context, index) {
                        final t = tasksForDay[index];
                        final slot = 8 + index;
                        return _TimelineRow(
                          timeLabel: '${slot.toString().padLeft(2, '0')} AM',
                          task: t,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _dateLabel(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final Color background;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.timeLabel,
    required this.task,
  });

  final String timeLabel;
  final TodoItem task;

  Color _backgroundColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return const Color(0xFFC7DA75);
      case Priority.medium:
        return const Color(0xFFB2A8DF);
      case Priority.high:
        return const Color(0xFF27282C);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _backgroundColor(task.priority);
    final dark = task.priority == Priority.high;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 56,
            child: Text(
              timeLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A4B50),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: dark ? Colors.white : const Color(0xFF191A1E),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          task.dueDate == null
                              ? '--:--'
                              : '${task.dueDate!.day.toString().padLeft(2, '0')}/${task.dueDate!.month.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: dark ? Colors.white70 : const Color(0xFF3A3B40),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.north_east_rounded,
                      size: 18,
                      color: Color(0xFF232428),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

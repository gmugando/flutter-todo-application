import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo_item.dart';
import '../viewmodels/todo_viewmodel.dart';
import 'add_edit_task_screen.dart';
import 'task_schedule_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  Color _surfaceColorForPriority(Priority p) {
    switch (p) {
      case Priority.low:
        return const Color(0xFFC7DA75);
      case Priority.medium:
        return const Color(0xFFB2A8DF);
      case Priority.high:
        return const Color(0xFF27282C);
    }
  }

  Color _accentColorForStatus(TodoStatus s) {
    switch (s) {
      case TodoStatus.pending:
        return const Color(0xFFE2E2E2);
      case TodoStatus.inProgress:
        return const Color(0xFFC7DA75);
      case TodoStatus.review:
        return const Color(0xFFB2A8DF);
      case TodoStatus.completed:
        return const Color(0xFF27282C);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TodoViewmodel>();
    final tasks = vm.tasks;
    final statusCounts = vm.countByStatus();
    final now = DateTime.now();
    final days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
    final bars = days.map((day) {
      final count = vm.tasksForDate(day).length;
      return (count / 4).clamp(0.12, 1.0).toDouble();
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          children: [
            Row(
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddEditTaskScreen(),
                      ),
                    );
                  },
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
            const SizedBox(height: 16),
            const Text(
              'Manage your task',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.7,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusPill(
                  label: 'In progress',
                  count: statusCounts[TodoStatus.inProgress] ?? 0,
                  background: const Color(0xFFB2A8DF),
                  textColor: const Color(0xFF17171A),
                ),
                _StatusPill(
                  label: 'In review',
                  count: statusCounts[TodoStatus.review] ?? 0,
                  background: const Color(0xFFE8E8E8),
                  textColor: const Color(0xFF17171A),
                ),
                _StatusPill(
                  label: 'Pending',
                  count: statusCounts[TodoStatus.pending] ?? 0,
                  background: const Color(0xFF27282C),
                  textColor: Colors.white,
                ),
                _StatusPill(
                  label: 'Completed',
                  count: statusCounts[TodoStatus.completed] ?? 0,
                  background: const Color(0xFFC7DA75),
                  textColor: const Color(0xFF17171A),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                _ModePill(
                  icon: Icons.calendar_month_outlined,
                  label: '',
                  selected: false,
                ),
                SizedBox(width: 8),
                _ModePill(label: 'Day', selected: false),
                SizedBox(width: 8),
                _ModePill(label: 'Week', selected: true),
                SizedBox(width: 8),
                _ModePill(label: 'Month', selected: false),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 208,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  bars.length,
                  (index) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: _BarColumn(
                        heightFactor: bars[index],
                        day: _weekday(days[index]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                days.length,
                (index) {
                  final selected = index == days.length - 1;
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF27282C) : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${days[index].day}',
                      style: TextStyle(
                        color:
                            selected ? Colors.white : const Color(0xFF313235),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Tasks',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B1C1F),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const TaskScheduleScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC7DA75),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...tasks.take(3).map((task) {
              final bg = _surfaceColorForPriority(task.priority);
              final accent = _accentColorForStatus(task.status);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddEditTaskScreen(task: task),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 12, 14),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  color: task.priority == Priority.high
                                      ? Colors.white
                                      : const Color(0xFF111216),
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              if ((task.description ?? '').trim().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    task.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: task.priority == Priority.high
                                          ? Colors.white70
                                          : const Color(0xFF35373C),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.north_east_rounded,
                                color: Color(0xFF202125),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: task.priority == Priority.high
                                      ? Colors.white38
                                      : Colors.white,
                                ),
                              ),
                              child: Text(
                                _statusText(task.status),
                                style: TextStyle(
                                  color: task.priority == Priority.high
                                      ? Colors.white
                                      : const Color(0xFF131419),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Checkbox(
                              value: task.isDone,
                              activeColor: accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              onChanged: (_) => vm.toggleCompletion(task.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (tasks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 22),
                child: Center(
                  child: Text(
                    'No tasks yet. Tap + to add one.',
                    style: TextStyle(color: Color(0xFF66676A)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _weekday(DateTime date) {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return days[date.weekday % 7];
  }

  static String _statusText(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return 'On hold';
      case TodoStatus.inProgress:
        return 'In progress';
      case TodoStatus.review:
        return 'In review';
      case TodoStatus.completed:
        return 'Completed';
    }
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

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.count,
    required this.background,
    required this.textColor,
  });

  final String label;
  final int count;
  final Color background;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(210),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$count',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Color(0xFF191A1E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  const _ModePill({
    this.icon,
    required this.label,
    required this.selected,
  });

  final IconData? icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: icon != null ? 10 : 18,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFC7DA75) : const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: icon != null
          ? const Icon(Icons.calendar_month_outlined, size: 20)
          : Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  const _BarColumn({
    required this.heightFactor,
    required this.day,
  });

  final double heightFactor;
  final String day;

  @override
  Widget build(BuildContext context) {
    final totalHeight = 180 * heightFactor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: double.infinity,
          height: totalHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E2E2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC7DA75),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  color: const Color(0xFFB2A8DF),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF27282C),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: const TextStyle(
            color: Color(0xFF4A4B50),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}


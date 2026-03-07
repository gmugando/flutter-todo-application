import 'package:flutter/material.dart';

import '../../models/todo_item.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  });

  final TodoItem task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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

  String _statusLabel(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return 'Pending';
      case TodoStatus.inProgress:
        return 'In Progress';
      case TodoStatus.review:
        return 'In Review';
      case TodoStatus.completed:
        return 'Completed';
    }
  }

  String _priorityLabel(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: _surfaceColorForPriority(task.priority),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and priority badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B1C1F),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _surfaceColorForPriority(task.priority).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _priorityLabel(task.priority),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _surfaceColorForPriority(task.priority),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Description if available
          if (task.description != null && task.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                task.description!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7D7D7D),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Status and action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _accentColorForStatus(task.status).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _statusLabel(task.status),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _accentColorForStatus(task.status),
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onEdit,
                    child: Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

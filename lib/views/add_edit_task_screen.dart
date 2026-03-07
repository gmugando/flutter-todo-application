import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/todo_item.dart';
import '../viewmodels/todo_viewmodel.dart';

class AddEditTaskScreen extends StatefulWidget {
  final TodoItem? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _description;
  DateTime? _dueDate;
  Priority _priority = Priority.medium;
  TodoStatus _status = TodoStatus.pending;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
      _status = widget.task!.status;
    } else {
      _title = '';
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (date != null) {
      setState(() {
        _dueDate = date;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final vm = context.read<TodoViewmodel>();
    if (widget.task != null) {
      final updated = widget.task!..title = _title;
      updated.description = _description;
      updated.dueDate = _dueDate;
      updated.priority = _priority;
      updated.status = _status;
      vm.updateTask(updated);
    } else {
      final id = const Uuid().v4();
      vm.addTask(TodoItem(
        id: id,
        title: _title,
        description: _description ?? '',
        dueDate: _dueDate,
        priority: _priority,
        status: _status,
      ));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8E8E8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE7E4F3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.more_horiz, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                isEditing ? 'Edit task' : 'New task',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.7,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: _title,
                      decoration: _fieldDecoration(
                        label: 'Task title',
                        hint: 'Enter task title',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please provide a title';
                        }
                        return null;
                      },
                      onSaved: (val) => _title = val!.trim(),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _description,
                      decoration: _fieldDecoration(
                        label: 'Description',
                        hint: 'Add details (optional)',
                      ),
                      maxLines: 4,
                      onSaved: (val) => _description = val?.trim(),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Schedule',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF26272B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              _dueDate == null
                                  ? 'No due date'
                                  : _formatDate(_dueDate!),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF202126),
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.chevron_right, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Priority',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF26272B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: Priority.values.map((p) {
                        final selected = _priority == p;
                        return ChoiceChip(
                          label: Text(_priorityLabel(p)),
                          selected: selected,
                          backgroundColor: const Color(0xFFF1F1F1),
                          selectedColor: _priorityColor(p),
                          labelStyle: TextStyle(
                            color: p == Priority.high && selected
                                ? Colors.white
                                : const Color(0xFF1D1E22),
                            fontWeight: FontWeight.w600,
                          ),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onSelected: (_) => setState(() => _priority = p),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF26272B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: TodoStatus.values.map((s) {
                        final selected = _status == s;
                        return ChoiceChip(
                          label: Text(_statusLabel(s)),
                          selected: selected,
                          backgroundColor: const Color(0xFFF1F1F1),
                          selectedColor: _statusColor(s),
                          labelStyle: TextStyle(
                            color: s == TodoStatus.completed && selected
                                ? Colors.white
                                : const Color(0xFF1D1E22),
                            fontWeight: FontWeight.w600,
                          ),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onSelected: (_) => setState(() => _status = s),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27282C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Save changes' : 'Create task',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF1F1F1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF27282C)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
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

  Color _priorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return const Color(0xFFC7DA75);
      case Priority.medium:
        return const Color(0xFFB2A8DF);
      case Priority.high:
        return const Color(0xFF27282C);
    }
  }

  String _statusLabel(TodoStatus status) {
    switch (status) {
      case TodoStatus.pending:
        return 'Pending';
      case TodoStatus.inProgress:
        return 'In progress';
      case TodoStatus.review:
        return 'In review';
      case TodoStatus.completed:
        return 'Completed';
    }
  }

  Color _statusColor(TodoStatus status) {
    switch (status) {
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
}

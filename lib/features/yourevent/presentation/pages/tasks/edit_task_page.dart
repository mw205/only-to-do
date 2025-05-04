import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/data/models/event_model.dart';
import '../../../services/firebase_service.dart';
import '../../cubits/events/events_cubit.dart';

class EditTaskPage extends StatefulWidget {
  final EventModel? task;

  const EditTaskPage({super.key, this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _taskDate = DateTime.now();
  TimeOfDay _taskTime = TimeOfDay.now();

  String _priority = 'Medium'; // Default priority
  bool _makeHabit = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      // Editing mode
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _taskDate = widget.task!.eventDate;
      _taskTime = TimeOfDay.fromDateTime(widget.task!.eventDate);

      // Set priority based on color
      if (widget.task!.color == '0xFFFF0000') {
        _priority = 'High';
      } else if (widget.task!.color == '0xFFFFAA00') {
        _priority = 'Medium';
      } else {
        _priority = 'Low';
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return '0xFFFF0000';
      case 'Medium':
        return '0xFFFFAA00';
      case 'Low':
        return '0xFF00FF00';
      default:
        return '0xFFFFAA00';
    }
  }

  DateTime _getTaskDateTime() {
    return DateTime(
      _taskDate.year,
      _taskDate.month,
      _taskDate.day,
      _taskTime.hour,
      _taskTime.minute,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _taskDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (picked != null && picked != _taskDate) {
      setState(() {
        _taskDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _taskTime,
    );

    if (picked != null && picked != _taskTime) {
      setState(() {
        _taskTime = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final firebaseService = FirebaseService();
      final userId = firebaseService.currentUserId;

      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
        return;
      }

      final taskDateTime = _getTaskDateTime();
      final priorityColor = _getPriorityColor(_priority);

      final EventModel task = widget.task != null
          ? widget.task!.copyWith(
              title: _titleController.text,
              description: _descriptionController.text,
              eventDate: taskDateTime,
              color: priorityColor,
              icon: 'event', // Default icon
            )
          : EventModel(
              id: const Uuid().v4(),
              title: _titleController.text,
              description: _descriptionController.text,
              eventDate: taskDateTime,
              reminderTimes: [],
              userId: userId,
              color: priorityColor,
              icon: 'event',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

      if (widget.task != null) {
        await context.read<EventsCubit>().updateEvent(task);
      } else {
        await context.read<EventsCubit>().createEvent(task);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving task: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit task' : 'New task'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveTask,
            child: Text(
              'Save task',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Add description',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 16),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a task description';
                }
                return null;
              },
            ),

            const Divider(),

            // Priority selector
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Priority'),
              trailing: DropdownButton<String>(
                value: _priority,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _priority = newValue;
                    });
                  }
                },
                items: <String>[
                  'Low',
                  'Medium',
                  'High',
                ].map<DropdownMenuItem<String>>((String value) {
                  Color color;
                  switch (value) {
                    case 'High':
                      color = Colors.red;
                      break;
                    case 'Medium':
                      color = Colors.orange;
                      break;
                    case 'Low':
                      color = Colors.green;
                      break;
                    default:
                      color = Colors.blue;
                  }
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            // Date selector
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date'),
              trailing: TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  DateFormat('MMM dd, yyyy').format(_taskDate),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),

            // Time selector
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Time'),
              trailing: TextButton(
                onPressed: () => _selectTime(context),
                child: Text(
                  _taskTime.format(context),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ),

            // Make habit toggle
            SwitchListTile(
              title: const Text('Make habit'),
              value: _makeHabit,
              onChanged: (bool value) {
                setState(() {
                  _makeHabit = value;
                });
              },
              secondary: const Icon(Icons.repeat),
            ),

            const Divider(),

            // Repeat section (only shown if make habit is enabled)
            if (_makeHabit)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Repeat every',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Days of week selectors
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildDaySelector('M', 1),
                        _buildDaySelector('T', 2),
                        _buildDaySelector('W', 3),
                        _buildDaySelector('T', 4),
                        _buildDaySelector('F', 5),
                        _buildDaySelector('S', 6),
                        _buildDaySelector('S', 7),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Track selected days in state
  final Set<int> _selectedDays = {};

  // Day selector widget for habit recurrence
  Widget _buildDaySelector(String day, int dayNumber) {
    final isSelected = _selectedDays.contains(dayNumber);

    return InkWell(
      onTap: () {
        // Toggle day selection
        setState(() {
          if (isSelected) {
            _selectedDays.remove(dayNumber);
          } else {
            _selectedDays.add(dayNumber);
          }
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/data/models/event_model.dart';
import '../../../services/firebase_service.dart';
import '../../cubits/events/events_cubit.dart';

class AddEditEventPage extends StatefulWidget {
  final EventModel? event;
  static const String id = 'add_edit_event_page';

  const AddEditEventPage({super.key, this.event});

  @override
  State<AddEditEventPage> createState() => _AddEditEventPageState();
}

class _AddEditEventPageState extends State<AddEditEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _eventDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _eventTime = TimeOfDay.now();

  List<DateTime> _reminderTimes = [];
  String _selectedColor = '0xFF6200EE'; // Default purple
  String _selectedIcon = 'event'; // Default event icon

  final List<Map<String, dynamic>> _colorOptions = [
    {'name': 'Purple', 'value': '0xFF6200EE'},
    {'name': 'Blue', 'value': '0xFF2196F3'},
    {'name': 'Green', 'value': '0xFF4CAF50'},
    {'name': 'Red', 'value': '0xFFF44336'},
    {'name': 'Orange', 'value': '0xFFFF9800'},
    {'name': 'Pink', 'value': '0xFFE91E63'},
  ];

  final List<Map<String, dynamic>> _iconOptions = [
    {'name': 'Event', 'value': 'event'},
    {'name': 'Birthday', 'value': 'birthday'},
    {'name': 'Meeting', 'value': 'meeting'},
    {'name': 'Deadline', 'value': 'deadline'},
    {'name': 'Alarm', 'value': 'alarm'},
    {'name': 'Travel', 'value': 'travel'},
    {'name': 'Holiday', 'value': 'holiday'},
    {'name': 'Work', 'value': 'work'},
    {'name': 'School', 'value': 'school'},
  ];

  bool _isLoading = false;

  @override
  @override
  void initState() {
    super.initState();

    // تأجيل العمليات التي تتطلب الـ BuildContext بعد اكتمال البناء
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.event != null) {
        // Editing mode
        _titleController.text = widget.event!.title;
        _descriptionController.text = widget.event!.description;
        _eventDate = widget.event!.eventDate;
        _eventTime = TimeOfDay.fromDateTime(widget.event!.eventDate);
        _reminderTimes = List.from(widget.event!.reminderTimes);
        _selectedColor = widget.event!.color ?? _selectedColor;
        _selectedIcon = widget.event!.icon ?? _selectedIcon;
      } else {
        // Add default reminder time (1 day before)
        _addReminderTime(1, 'days');
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addReminderTime(int value, String unit) {
    final DateTime now = DateTime.now();
    late DateTime reminderTime;

    switch (unit) {
      case 'minutes':
        reminderTime = _getEventDateTime().subtract(Duration(minutes: value));
        break;
      case 'hours':
        reminderTime = _getEventDateTime().subtract(Duration(hours: value));
        break;
      case 'days':
        reminderTime = _getEventDateTime().subtract(Duration(days: value));
        break;
      case 'weeks':
        reminderTime = _getEventDateTime().subtract(Duration(days: value * 7));
        break;
    }

    // Don't add reminder times in the past
    if (reminderTime.isAfter(now)) {
      setState(() {
        _reminderTimes.add(reminderTime);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot add reminder times in the past')),
      );
    }
  }

  void _removeReminderTime(int index) {
    setState(() {
      _reminderTimes.removeAt(index);
    });
  }

  DateTime _getEventDateTime() {
    return DateTime(
      _eventDate.year,
      _eventDate.month,
      _eventDate.day,
      _eventTime.hour,
      _eventTime.minute,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );

    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _eventTime,
    );

    if (picked != null && picked != _eventTime) {
      setState(() {
        _eventTime = picked;
      });
    }
  }

  Future<void> _saveEvent() async {
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

      final eventDateTime = _getEventDateTime();

      // Sort reminder times
      _reminderTimes.sort((a, b) => a.compareTo(b));

      final EventModel event = widget.event != null
          ? widget.event!.copyWith(
              title: _titleController.text,
              description: _descriptionController.text,
              eventDate: eventDateTime,
              reminderTimes: _reminderTimes,
              color: _selectedColor,
              icon: _selectedIcon,
            )
          : EventModel(
              id: const Uuid().v4(),
              title: _titleController.text,
              description: _descriptionController.text,
              eventDate: eventDateTime,
              reminderTimes: _reminderTimes,
              userId: userId,
              color: _selectedColor,
              icon: _selectedIcon,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

      if (widget.event != null) {
        await context.read<EventsCubit>().updateEvent(event);
      } else {
        await context.read<EventsCubit>().createEvent(event);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving event: ${e.toString()}')),
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
    final isEditing = widget.event != null;
    final eventDateTime = _getEventDateTime();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Event' : 'Create New Event'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an event title';
                }
                return null;
              },
            ),
            const Gap(16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const Gap(24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Event Date & Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                                labelText: 'Date',
                              ),
                              child: Text(
                                DateFormat('MMM dd, yyyy').format(_eventDate),
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectTime(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.access_time),
                                labelText: 'Time',
                              ),
                              child: Text(_eventTime.format(context)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Reminders',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => _showAddReminderDialog(context),
                        ),
                      ],
                    ),
                    const Gap(8),
                    if (_reminderTimes.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text('No reminders set'),
                      )
                    else
                      Column(
                        children: List.generate(
                          _reminderTimes.length,
                          (index) => ListTile(
                            leading: const Icon(Icons.notifications),
                            title: Text(
                              _formatReminderTime(
                                eventDateTime,
                                _reminderTimes[index],
                              ),
                            ),
                            subtitle: Text(
                              DateFormat(
                                'MMM dd, yyyy - h:mm a',
                              ).format(_reminderTimes[index]),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _removeReminderTime(index),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Gap(24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appearance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap(16),
                    const Text(
                      'Event Color',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Gap(8),
                    Wrap(
                      spacing: 8,
                      children: _colorOptions.map((color) {
                        final colorValue = int.parse(color['value']);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedColor = color['value'];
                            });
                          },
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(colorValue),
                            child: _selectedColor == color['value']
                                ? const Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const Gap(16),
                    const Text(
                      'Event Icon',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const Gap(8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _iconOptions.map((icon) {
                        final isSelected = _selectedIcon == icon['value'];
                        final colorValue = int.parse(_selectedColor);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIcon = icon['value'];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(
                                      colorValue,
                                    ).withValues(alpha: .2)
                                  : Colors.grey.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? Color(colorValue)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getIconData(icon['value']),
                                  size: 18,
                                  color: isSelected
                                      ? Color(colorValue)
                                      : Colors.grey[600],
                                ),
                                const Gap(4),
                                Text(
                                  icon['name'],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Color(colorValue)
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(32),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveEvent,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      isEditing ? 'Update Event' : 'Create Event',
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context) {
    int reminderValue = 1;
    String reminderUnit = 'days';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Reminder'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Remind me before the event:'),
              const Gap(16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: reminderValue,
                      items: List.generate(60, (index) => index + 1)
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value.toString()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            reminderValue = value;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Value',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: reminderUnit,
                      items: const [
                        DropdownMenuItem(
                          value: 'minutes',
                          child: Text('Minutes'),
                        ),
                        DropdownMenuItem(
                          value: 'hours',
                          child: Text('Hours'),
                        ),
                        DropdownMenuItem(
                          value: 'days',
                          child: Text('Days'),
                        ),
                        DropdownMenuItem(
                          value: 'weeks',
                          child: Text('Weeks'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            reminderUnit = value;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _addReminderTime(reminderValue, reminderUnit);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  String _formatReminderTime(DateTime eventDate, DateTime reminderTime) {
    final difference = eventDate.difference(reminderTime);

    if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} before';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} before';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} before';
    } else {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} before';
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'event':
        return Icons.event;
      case 'birthday':
        return Icons.cake;
      case 'meeting':
        return Icons.people;
      case 'deadline':
        return Icons.assignment_late;
      case 'alarm':
        return Icons.alarm;
      case 'travel':
        return Icons.flight;
      case 'holiday':
        return Icons.beach_access;
      case 'work':
        return Icons.work;
      case 'school':
        return Icons.school;
      default:
        return Icons.event;
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/data/models/event_model.dart';
import '../../cubits/events/events_cubit.dart';
import '../../cubits/events/events_state.dart';
import '../tasks/edit_task_page.dart';
import '../tasks/task_detail_page.dart';

class WeeklyViewPage extends StatefulWidget {
  const WeeklyViewPage({super.key});
  static const String id = 'weekly_view_page';

  @override
  State<WeeklyViewPage> createState() => _WeeklyViewPageState();
}

class _WeeklyViewPageState extends State<WeeklyViewPage> {
  late DateTime _selectedDate;
  late DateTime _weekStart;
  List<EventModel> _weekEvents = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _calculateWeekStartDate();

    // Load events
    context.read<EventsCubit>().loadEvents();
  }

  void _calculateWeekStartDate() {
    // Find the start of the week (Sunday)
    final weekday = _selectedDate.weekday % 7;
    _weekStart = _selectedDate.subtract(Duration(days: weekday));
  }

  void _filterWeekEvents(List<EventModel> allEvents) {
    // Calculate week end date
    final weekEnd = _weekStart.add(const Duration(days: 7));

    setState(() {
      _weekEvents = allEvents.where((event) {
        return event.eventDate.isAfter(_weekStart) &&
            event.eventDate.isBefore(weekEnd);
      }).toList();
    });
  }

  void _previousWeek() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      _calculateWeekStartDate();
    });

    // Re-filter events for new week
    if (context.read<EventsCubit>().state.status == EventsStatus.success) {
      _filterWeekEvents(context.read<EventsCubit>().state.events);
    }
  }

  void _nextWeek() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 7));
      _calculateWeekStartDate();
    });

    // Re-filter events for new week
    if (context.read<EventsCubit>().state.status == EventsStatus.success) {
      _filterWeekEvents(context.read<EventsCubit>().state.events);
    }
  }

  void _navigateToTaskDetail(EventModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailPage(task: task)),
    );
  }

  void _navigateToNewTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditTaskPage()),
    );

    if (result == true) {
      context.read<EventsCubit>().loadEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<EventsCubit, EventsState>(
        listener: (context, state) {
          if (state.status == EventsStatus.success) {
            _filterWeekEvents(state.events);
          }
        },
        builder: (context, state) {
          if (state.status == EventsStatus.loading && state.events.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildWeekHeader(),
              _buildWeekDays(),
              Expanded(child: _buildWeekTasksList()),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewTask,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildWeekHeader() {
    final weekEnd = _weekStart.add(const Duration(days: 6));
    final formattedStart = DateFormat('MMM d').format(_weekStart);
    final formattedEnd = DateFormat('MMM d').format(weekEnd);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousWeek,
          ),
          Text(
            '$formattedStart - $formattedEnd',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextWeek,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          final date = _weekStart.add(Duration(days: index));
          final day = DateFormat('E').format(date)[0]; // First letter of day
          final dayNum = date.day.toString();

          final isToday = date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day,
                style: TextStyle(
                  color: isToday
                      ? Theme.of(context).primaryColor
                      : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isToday
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    dayNum,
                    style: TextStyle(
                      color: isToday ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildWeekTasksList() {
    if (_weekEvents.isEmpty) {
      return Center(
        child: Text(
          'No tasks this week',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    // Group events by day
    final Map<String, List<EventModel>> eventsByDay = {};

    for (final event in _weekEvents) {
      final dayKey = DateFormat('yyyy-MM-dd').format(event.eventDate);
      if (!eventsByDay.containsKey(dayKey)) {
        eventsByDay[dayKey] = [];
      }
      eventsByDay[dayKey]!.add(event);
    }

    // Sort days
    final sortedDays = eventsByDay.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedDays.length,
      itemBuilder: (context, index) {
        final dayKey = sortedDays[index];
        final date = DateTime.parse(dayKey);
        final dayEvents = eventsByDay[dayKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                DateFormat('EEEE, MMMM d').format(date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...dayEvents.map((event) => _buildTaskItem(event)),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget _buildTaskItem(EventModel task) {
    // Get priority color
    Color priorityColor;
    switch (task.color) {
      case '0xFFFF0000': // Red
        priorityColor = Colors.red;
        break;
      case '0xFFFFAA00': // Orange/Yellow
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => _navigateToTaskDetail(task),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Time
                SizedBox(
                  width: 60,
                  child: Text(
                    DateFormat('h:mm a').format(task.eventDate),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
                // Priority indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: priorityColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                // Task content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      if (task.description.isNotEmpty)
                        Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                // Checkbox for completion
                Checkbox(
                  value: task.isCompleted,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<EventsCubit>().markEventAsCompleted(
                            task.id,
                            value,
                          );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

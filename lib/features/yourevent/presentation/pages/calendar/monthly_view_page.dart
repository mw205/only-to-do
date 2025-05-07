// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../../core/data/models/event_model.dart';
import '../../cubits/events/events_cubit.dart';
import '../../cubits/events/events_state.dart';
import '../tasks/edit_task_page.dart';
import '../tasks/task_detail_page.dart';

class MonthlyViewPage extends StatefulWidget {
  const MonthlyViewPage({super.key});
  static const String id = '/monthly-view';

  @override
  State<MonthlyViewPage> createState() => _MonthlyViewPageState();
}

class _MonthlyViewPageState extends State<MonthlyViewPage> {
  late DateTime _selectedDate;
  late DateTime _monthStart;
  late List<DateTime> _daysInMonth;
  Map<String, List<EventModel>> _eventsByDay = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _calculateMonthDates();

    // Load events
    context.read<EventsCubit>().loadEvents();
  }

  void _calculateMonthDates() {
    // Find the first day of the month
    _monthStart = DateTime(_selectedDate.year, _selectedDate.month, 1);

    // Calculate days to display in grid (previous month, current month, next month)
    _daysInMonth = [];

    // Get the weekday of the first day (0 = Sunday, 6 = Saturday)
    final firstDayWeekday = _monthStart.weekday % 7;

    // Add days from previous month
    for (int i = 0; i < firstDayWeekday; i++) {
      _daysInMonth.add(
        _monthStart.subtract(Duration(days: firstDayWeekday - i)),
      );
    }

    // Add days of current month
    final daysInMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    for (int i = 0; i < daysInMonth; i++) {
      _daysInMonth.add(_monthStart.add(Duration(days: i)));
    }

    // Add days from next month to complete the grid
    final remainingDays = (42 - _daysInMonth.length); // 6 rows x 7 days
    for (int i = 0; i < remainingDays; i++) {
      _daysInMonth.add(
        DateTime(_selectedDate.year, _selectedDate.month + 1, i + 1),
      );
    }
  }

  void _filterMonthEvents(List<EventModel> allEvents) {
    final startFilter = _daysInMonth.first;
    final endFilter = _daysInMonth.last.add(const Duration(days: 1));

    // Filter events within month view range
    final filteredEvents = allEvents.where((event) {
      return event.eventDate.isAfter(startFilter) &&
          event.eventDate.isBefore(endFilter);
    }).toList();

    // Group by day
    _eventsByDay = {};
    for (final event in filteredEvents) {
      final dayKey = DateFormat('yyyy-MM-dd').format(event.eventDate);
      if (!_eventsByDay.containsKey(dayKey)) {
        _eventsByDay[dayKey] = [];
      }
      _eventsByDay[dayKey]!.add(event);
    }

    setState(() {});
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
      _calculateMonthDates();
    });

    // Re-filter events for new month
    if (context.read<EventsCubit>().state.status == EventsStatus.success) {
      _filterMonthEvents(context.read<EventsCubit>().state.events);
    }
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
      _calculateMonthDates();
    });

    // Re-filter events for new month
    if (context.read<EventsCubit>().state.status == EventsStatus.success) {
      _filterMonthEvents(context.read<EventsCubit>().state.events);
    }
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });

    // Show events for selected date
    _showDayEventsDialog(date);
  }

  void _showDayEventsDialog(DateTime date) {
    final dayKey = DateFormat('yyyy-MM-dd').format(date);
    final dayEvents = _eventsByDay[dayKey] ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEEE, MMMM d').format(date),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.pop(context);
                      _navigateToNewTask(date);
                    },
                  ),
                ],
              ),
              const Divider(),
              if (dayEvents.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('No tasks for this day')),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: dayEvents.length,
                    itemBuilder: (context, index) {
                      return _buildEventItem(dayEvents[index]);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToTaskDetail(EventModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailPage(task: task)),
    );
  }

  void _navigateToNewTask([DateTime? date]) async {
    // If date is provided, create task with that date

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTaskPage()),
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
            _filterMonthEvents(state.events);
          }
        },
        builder: (context, state) {
          if (state.status == EventsStatus.loading && state.events.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildMonthHeader(),
              _buildWeekdayLabels(),
              _buildCalendarGrid(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToNewTask(),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _previousMonth,
          ),
          Text(
            DateFormat('MMMM yyyy').format(_selectedDate),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    const weekdays = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekdays.map((day) {
          return SizedBox(
            width: 40,
            child: Text(
              day,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.0,
        ),
        itemCount: _daysInMonth.length,
        itemBuilder: (context, index) {
          final date = _daysInMonth[index];
          final isCurrentMonth = date.month == _selectedDate.month;
          final isToday = DateTime.now().year == date.year &&
              DateTime.now().month == date.month &&
              DateTime.now().day == date.day;

          // Check if there are events for this day
          final dayKey = DateFormat('yyyy-MM-dd').format(date);
          final hasEvents = _eventsByDay.containsKey(dayKey);

          return InkWell(
            onTap: () => _selectDate(date),
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isToday
                    ? Theme.of(context).primaryColor.withValues(alpha: .1)
                    : null,
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isCurrentMonth ? Colors.black : Colors.grey[400],
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (hasEvents)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventItem(EventModel event) {
    // Get priority color
    Color priorityColor;
    switch (event.color) {
      case '0xFFFF0000': // Red
        priorityColor = Colors.red;
        break;
      case '0xFFFFAA00': // Orange/Yellow
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('h:mm a').format(event.eventDate),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const Gap(8),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: priorityColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      title: Text(
        event.title,
        style: TextStyle(
          decoration: event.isCompleted ? TextDecoration.lineThrough : null,
          color: event.isCompleted ? Colors.grey : Colors.black,
        ),
      ),
      trailing: Checkbox(
        value: event.isCompleted,
        activeColor: Theme.of(context).primaryColor,
        onChanged: (value) {
          if (value != null) {
            context.read<EventsCubit>().markEventAsCompleted(event.id, value);
            Navigator.pop(context);
          }
        },
      ),
      onTap: () {
        Navigator.pop(context);
        _navigateToTaskDetail(event);
      },
    );
  }
}

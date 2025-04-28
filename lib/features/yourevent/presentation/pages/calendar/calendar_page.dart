import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../data/models/event_model.dart';
import '../../cubits/events/events_cubit.dart';
import '../../cubits/events/events_state.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  static const String id = 'calendar-page';
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with SingleTickerProviderStateMixin {
  // View mode: 0 for weekly, 1 for monthly
  int _viewMode = 0;
  late AnimationController _animationController;
  late Animation<double> animation;
  late PageController _pageController;

  DateTime _selectedDate = DateTime.now();
  late DateTime _weekStart;
  List<DateTime> _daysInMonth = [];
  List<EventModel> todayEvents = [];
  Map<String, List<EventModel>> _eventsByDay = {};

  @override
  void initState() {
    super.initState();
    _calculateWeekStartDate();
    _calculateMonthDates();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Initialize page controller for horizontal swipe
    _pageController = PageController(initialPage: _viewMode);

    // Load events
    context.read<EventsCubit>().loadEvents();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _calculateWeekStartDate() {
    // Find the start of the week (Sunday)
    final weekday = _selectedDate.weekday % 7;
    _weekStart = _selectedDate.subtract(Duration(days: weekday));
  }

  void _calculateMonthDates() {
    // Find the first day of the month
    final monthStart = DateTime(_selectedDate.year, _selectedDate.month, 1);

    // Calculate days to display in grid
    _daysInMonth = [];

    // Get the weekday of the first day (0 = Sunday, 6 = Saturday)
    final firstDayWeekday = monthStart.weekday % 7;

    // Add days from previous month
    for (int i = 0; i < firstDayWeekday; i++) {
      _daysInMonth.add(
        monthStart.subtract(Duration(days: firstDayWeekday - i)),
      );
    }

    // Add days of current month
    final daysInMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    for (int i = 0; i < daysInMonth; i++) {
      _daysInMonth.add(monthStart.add(Duration(days: i)));
    }

    // Add days from next month to complete the grid
    final remainingDays = (42 - _daysInMonth.length); // 6 rows x 7 days
    for (int i = 0; i < remainingDays; i++) {
      _daysInMonth.add(
        DateTime(_selectedDate.year, _selectedDate.month + 1, i + 1),
      );
    }
  }

  void _filterEvents(List<EventModel> allEvents) {
    // Filter events for selected date
    final today = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    todayEvents = allEvents.where((event) {
      final eventDay = DateTime(
        event.eventDate.year,
        event.eventDate.month,
        event.eventDate.day,
      );
      return eventDay.isAtSameMomentAs(today);
    }).toList();

    // Group all events by day for calendar
    _eventsByDay = {};
    for (final event in allEvents) {
      final dayKey = DateFormat('yyyy-MM-dd').format(event.eventDate);
      if (!_eventsByDay.containsKey(dayKey)) {
        _eventsByDay[dayKey] = [];
      }
      _eventsByDay[dayKey]!.add(event);
    }

    setState(() {});
  }

  void _toggleViewMode(int mode) {
    if (_viewMode == mode) return;

    setState(() {
      _viewMode = mode;
      _pageController.animateToPage(
        mode,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });

    // Re-filter events for selected date
    if (context.read<EventsCubit>().state.status == EventsStatus.success) {
      _filterEvents(context.read<EventsCubit>().state.events);
    }
  }

  void _markTaskCompleted(String taskId, bool completed) {
    context.read<EventsCubit>().markEventAsCompleted(taskId, completed);
  }

  void _navigateToNewTask() {
    // Navigate to add task page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocConsumer<EventsCubit, EventsState>(
        listener: (context, state) {
          if (state.status == EventsStatus.success) {
            _filterEvents(state.events);
          }
        },
        builder: (context, state) {
          if (state.status == EventsStatus.loading && state.events.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Calendar section
              _buildCalendarHeader(),

              // Task list section
              Expanded(child: _buildTasksSection()),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewTask,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // View selector buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {},
                ),

                // View mode toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _toggleViewMode(1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _viewMode == 1
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Month',
                            style: TextStyle(
                              color:
                                  _viewMode == 1 ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _toggleViewMode(0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _viewMode == 0
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Week',
                            style: TextStyle(
                              color:
                                  _viewMode == 0 ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Day of week labels
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('S', style: TextStyle(color: Colors.white)),
                Text('M', style: TextStyle(color: Colors.white)),
                Text('T', style: TextStyle(color: Colors.white)),
                Text('W', style: TextStyle(color: Colors.white)),
                Text('T', style: TextStyle(color: Colors.white)),
                Text('F', style: TextStyle(color: Colors.white)),
                Text('S', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),

          // Calendar views with page view for swipe transition
          SizedBox(
            height: _viewMode == 0
                ? 70
                : 230, // Different heights for weekly/monthly view
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _viewMode = index;
                });
              },
              children: [_buildWeeklyCalendar(), _buildMonthlyCalendar()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyCalendar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final date = _weekStart.add(Duration(days: index));
              final isSelected = date.year == _selectedDate.year &&
                  date.month == _selectedDate.month &&
                  date.day == _selectedDate.day;

              return GestureDetector(
                onTap: () => _selectDate(date),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          // Selected date indicator
          Container(width: 32, height: 2, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildMonthlyCalendar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
              ),
              itemCount: _daysInMonth.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final date = _daysInMonth[index];
                final isCurrentMonth = date.month == _selectedDate.month;
                final isSelected = date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day;

                return GestureDetector(
                  onTap: () => _selectDate(date),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(isSelected ? 12 : 0),
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: !isCurrentMonth
                              ? Colors.white.withValues(alpha: .4)
                              : (isSelected ? Colors.black : Colors.white),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Selected date indicator
          Container(width: 32, height: 2, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    // For demo purposes, using static data to match the screenshot
    final sampleTasks = [
      _createSampleTask('E-mail Fred about job proposal'),
      _createSampleTask('Update portfolio'),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Apr 21, Sunday",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'On this day',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Today section
            const Text(
              'Today',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Sample tasks to match screenshot
            ...sampleTasks.map((task) => _buildTaskItem(task)),

            const Divider(height: 32),

            // Assign to day section
            const Text(
              'Assign to day',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Assignable tasks
            _buildAssignableTaskItem('Bake a cake'),
            _buildAssignableTaskItem('Call grandma'),
          ],
        ),
      ),
    );
  }

  EventModel _createSampleTask(String title) {
    return EventModel(
      id: title.hashCode.toString(),
      title: title,
      description: '',
      eventDate: DateTime.now(),
      reminderTimes: [],
      userId: 'user',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Widget _buildTaskItem(EventModel task) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: task.isCompleted ? Colors.deepPurple : Colors.grey,
                width: 1.5,
              ),
              color: task.isCompleted ? Colors.deepPurple : Colors.transparent,
            ),
            child: task.isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          onTap: () => _markTaskCompleted(task.id, !task.isCompleted),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildAssignableTaskItem(String title) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
            child: const Icon(Icons.add, size: 16, color: Colors.deepPurple),
          ),
          title: Text(title),
          onTap: () {
            // Handle assigning task to selected day
          },
        ),
        const Divider(height: 1),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../../core/data/models/daily_tracker_model.dart';
import '../../cubits/dashboard/dashboard_cubit.dart';
import '../../cubits/dashboard/dashboard_state.dart';
import '../../widgets/charts/performance_chart.dart';
import '../../widgets/charts/habit_tracker_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const String id = 'dashboard_page';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  final _taskController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboard();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      final period = _getPeriodFromTabIndex(_tabController.index);
      context.read<DashboardCubit>().changePeriod(period);
    });
  }

  DashboardPeriod _getPeriodFromTabIndex(int index) {
    switch (index) {
      case 0:
        return DashboardPeriod.daily;
      case 1:
        return DashboardPeriod.weekly;
      case 2:
        return DashboardPeriod.monthly;
      default:
        return DashboardPeriod.weekly;
    }
  }

  @override
  void dispose() {
    _taskController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DashboardCubit, DashboardState>(
        listener: (context, state) {
          if (state.status == DashboardStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An error occurred'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == DashboardStatus.initial) {
            return const Center(
              child: Text(
                'Loading dashboard...',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          if (state.status == DashboardStatus.loading &&
              state.todayTracker == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, state),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCards(context, state),
                    _buildTabBar(),
                    _buildChartSection(context, state),
                    const SizedBox(height: 16),
                    if (state.todayTracker != null)
                      _buildDailyTrackingSection(context, state),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Build the app bar
  Widget _buildSliverAppBar(BuildContext context, DashboardState state) {
    return SliverAppBar(
      expandedHeight: 180.0,
      floating: true,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => context.read<DashboardCubit>().loadDashboard(),
          tooltip: 'Refresh',
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: .7),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Welcome to your Dashboard',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build summary cards
  Widget _buildSummaryCards(BuildContext context, DashboardState state) {
    if (state.todayTracker == null) return const SizedBox.shrink();

    final tracker = state.todayTracker!;
    final hasEvents = tracker.totalEvents > 0;
    final completionPercentage = hasEvents
        ? (tracker.completedEvents / tracker.totalEvents * 100).toInt()
        : 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Today\'s Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStatCard(
                  context,
                  'Completed Tasks',
                  '${hasEvents ? tracker.completedEvents : 0}/${hasEvents ? tracker.totalEvents : 0}',
                  completionPercentage / 100,
                  colors: [Colors.blue.shade300, Colors.blue.shade600],
                  icon: Icons.event,
                ),
                _buildStatCard(
                  context,
                  'Pomodoro Sessions',
                  '${tracker.completedPomodoroSessions}',
                  tracker.completedPomodoroSessions /
                      8, // Assuming 8 sessions is the goal
                  colors: [Colors.red.shade300, Colors.red.shade600],
                  icon: Icons.timer,
                ),
                _buildStatCard(
                  context,
                  'Steps',
                  '${tracker.steps}/10,000',
                  tracker.steps / 10000,
                  colors: [Colors.green.shade300, Colors.green.shade600],
                  icon: Icons.directions_walk,
                ),
                _buildStatCard(
                  context,
                  'Sleep',
                  '${tracker.sleepHours} hours',
                  tracker.sleepHours / 8, // Assuming 8 hours is the goal
                  colors: [Colors.purple.shade300, Colors.purple.shade600],
                  icon: Icons.bedtime,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build stat card
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    double progress, {
    required List<Color> colors,
    required IconData icon,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: .3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: .3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              borderRadius: BorderRadius.circular(4),
              minHeight: 6,
            ),
          ],
        ),
      ),
    );
  }

  // Build tab bar

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade700,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 8,
        ), // Add more horizontal space for tabs
        tabs: [
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ), // Slightly reduce horizontal padding
              child: const Text('Daily', style: TextStyle(fontSize: 16)),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: const Text('Weekly', style: TextStyle(fontSize: 16)),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: const Text(
                'Monthly',
                style: TextStyle(fontSize: 16),
                overflow: TextOverflow.visible, // Prevent text truncation
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build chart section
  Widget _buildChartSection(BuildContext context, DashboardState state) {
    if (state.periodTrackers.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'Not enough data to display charts',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildDailyChartView(context, state),
          _buildWeeklyChartView(context, state),
          _buildMonthlyChartView(context, state),
        ],
      ),
    );
  }

  // Daily chart view
  Widget _buildDailyChartView(BuildContext context, DashboardState state) {
    if (state.todayTracker == null) return const SizedBox.shrink();

    final tracker = state.todayTracker!;
    final data = [
      {'name': 'Tasks', 'value': tracker.completedEvents, 'color': Colors.blue},
      {
        'name': 'Pomodoro',
        'value': tracker.completedPomodoroSessions,
        'color': Colors.red,
      },
      {
        'name': 'Sleep Hours',
        'value': tracker.sleepHours,
        'color': Colors.purple,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 10),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: data
                    .map(
                      (item) => _buildDailyStatItem(
                        context,
                        item['name'] as String,
                        item['value'] as int,
                        item['color'] as Color,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build daily stat item
  Widget _buildDailyStatItem(
    BuildContext context,
    String name,
    int value,
    Color color,
  ) {
    // Determine appropriate max value for each data type
    int maxValue = 10; // Default value
    if (name == 'Tasks') {
      maxValue = 10;
    } else if (name == 'Pomodoro') {
      maxValue = 8;
    } else if (name == 'Sleep Hours') {
      maxValue = 12;
    }

    double percentage = (value / maxValue).clamp(0.0, 1.0);

    return Column(
      children: [
        CircularPercentIndicator(
          radius: 40.0,
          lineWidth: 8.0,
          percent: percentage,
          center: Text(
            value.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
          progressColor: color,
          backgroundColor: color.withValues(alpha: .2),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        Text(
          '${(percentage * 100).toInt()}%',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // Weekly chart view
  Widget _buildWeeklyChartView(BuildContext context, DashboardState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 10),
        ],
      ),
      child: PerformanceChart(
        trackers: state.periodTrackers,
        title: 'Weekly Performance',
        subtitle: 'Track your weekly activity progress',
        lineColor: Colors.blue,
        gradientColor: Colors.blue,
        valueExtractor: (tracker) => tracker.completedEvents.toDouble(),
        tooltipFormatter: (value) => '${value.toInt()} tasks',
        maxY: _getMaxValue(
          state.periodTrackers,
          (tracker) => tracker.completedEvents.toDouble(),
        ),
      ),
    );
  }

  // Monthly chart view
  Widget _buildMonthlyChartView(BuildContext context, DashboardState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 10),
        ],
      ),
      child: HabitTrackerChart(
        trackers: state.periodTrackers,
        title: 'Monthly Habit Tracking',
        valueExtractor: (tracker) => tracker.dietTracked,
        activeColor: Colors.green,
      ),
    );
  }

  // Daily tracking section
  Widget _buildDailyTrackingSection(
    BuildContext context,
    DashboardState state,
  ) {
    final tracker = state.todayTracker!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Daily Tracking',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Tracking cards
          _buildSleepTracker(tracker),
          const SizedBox(height: 16),
          _buildWaterIntakeTracker(tracker),
          const SizedBox(height: 16),
          _buildDietTracker(tracker),
          const SizedBox(height: 16),
          _buildStepsTracker(tracker),
          const SizedBox(height: 16),
          _buildTasksSection(tracker),
          const SizedBox(height: 16),
          _buildQuickGoalsCard(context),
          const SizedBox(height: 16),
          _buildHealthTipsCard(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Sleep tracker
  Widget _buildSleepTracker(DailyTrackerModel tracker) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.bedtime, color: Colors.indigo[900]),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Sleep',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${tracker.sleepHours} hours',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Slider(
              value: tracker.sleepHours.toDouble(),
              min: 0,
              max: 12,
              divisions: 12,
              label: '${tracker.sleepHours} hours',
              activeColor: Colors.indigo[700],
              inactiveColor: Colors.indigo[100],
              onChanged: (value) {
                context.read<DashboardCubit>().updateSleepHours(value.toInt());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0h',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                Text(
                  '12h',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Water intake tracker
  Widget _buildWaterIntakeTracker(DailyTrackerModel tracker) {
    // Convert ml to cups (1 cup = 240 ml)
    final cups = (tracker.waterIntake / 240).toStringAsFixed(1);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.water_drop, color: Colors.blue[900]),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Water Intake',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$cups cups (${tracker.waterIntake} ml)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                8,
                (index) => GestureDetector(
                  onTap: () {
                    // Each cup is 240ml
                    context.read<DashboardCubit>().updateWaterIntake(
                          (index + 1) * 240,
                        );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 36,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (index + 1) * 240 <= tracker.waterIntake
                          ? Colors.blue[400]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.water_drop,
                      color: (index + 1) * 240 <= tracker.waterIntake
                          ? Colors.white
                          : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Diet tracker
  Widget _buildDietTracker(DailyTrackerModel tracker) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.restaurant, color: Colors.orange[900]),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Diet Tracking',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Switch(
              value: tracker.dietTracked,
              onChanged: (value) {
                context.read<DashboardCubit>().toggleDietTracked(value);
              },
              activeColor: Colors.green,
              activeTrackColor: Colors.green.withValues(alpha: .5),
            ),
          ],
        ),
      ),
    );
  }

  // Steps tracker
  Widget _buildStepsTracker(DailyTrackerModel tracker) {
    // Calculate percentage of daily goal (10,000 steps)
    final percentage = (tracker.steps / 10000).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.directions_walk,
                        color: Colors.green[900],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Steps',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${tracker.steps} / 10,000',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[500]!),
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Add 1,000 steps
                    final newSteps = tracker.steps + 1000;
                    context.read<DashboardCubit>().updateSteps(newSteps);
                  },
                  icon: Icon(Icons.add, color: Colors.green[700]),
                  label: Text(
                    '+1,000',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Manually enter steps
                    _showStepsInputDialog(context, tracker.steps);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Enter Steps'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Tasks section
  Widget _buildTasksSection(DailyTrackerModel tracker) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.task_alt, color: Colors.teal[900]),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Daily Tasks',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: 'Add a new task',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal.shade500),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.teal[700]),
                  onPressed: () {
                    if (_taskController.text.isNotEmpty) {
                      context.read<DashboardCubit>().addCompletedTask(
                            _taskController.text,
                          );
                      _taskController.clear();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (tracker.completedTasks.isNotEmpty)
              ...tracker.completedTasks.map(
                (task) => _buildTaskItem(context, task),
              ),
            if (tracker.completedTasks.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No tasks added yet',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Build task item
  Widget _buildTaskItem(BuildContext context, String task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.teal.shade500,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(task, style: const TextStyle(fontSize: 15))),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 20, color: Colors.red[700]),
            onPressed: () {
              context.read<DashboardCubit>().removeCompletedTask(task);
            },
          ),
        ],
      ),
    );
  }

  // Show steps input dialog
  void _showStepsInputDialog(BuildContext context, int currentSteps) {
    int steps = currentSteps;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Steps'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter number of steps',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.directions_walk),
              ),
              onChanged: (value) {
                steps = int.tryParse(value) ?? currentSteps;
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Recommended goal: 10,000 steps daily',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DashboardCubit>().updateSteps(steps);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Get max value from trackers for chart
  double _getMaxValue(
    List<DailyTrackerModel> trackers,
    double Function(DailyTrackerModel) extractor,
  ) {
    if (trackers.isEmpty) return 10.0;

    double maxValue = 0;
    for (final tracker in trackers) {
      final value = extractor(tracker);
      if (value > maxValue) {
        maxValue = value;
      }
    }

    // Add a small padding to the max value
    return maxValue == 0 ? 10.0 : (maxValue * 1.2).ceilToDouble();
  }

  // Create additional components to make the dashboard more appealing

  // Quick goals card
  Widget _buildQuickGoalsCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple.shade600, Colors.deepPurple.shade800],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withValues(alpha: .3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Daily Goals',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGoalItem(Icons.directions_walk, '10,000', 'steps', 0.65),
              _buildGoalItem(Icons.local_drink, '8', 'cups', 0.5),
              _buildGoalItem(Icons.timer, '4', 'sessions', 0.75),
              _buildGoalItem(Icons.bedtime, '8', 'hours', 0.4),
            ],
          ),
        ],
      ),
    );
  }

  // Build goal item
  Widget _buildGoalItem(
    IconData icon,
    String value,
    String label,
    double progress,
  ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                backgroundColor: Colors.white.withValues(alpha: .2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Icon(icon, color: Colors.white, size: 24),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Health tips card
  Widget _buildHealthTipsCard(BuildContext context) {
    final tips = [
      'Aim to drink 8 cups of water daily',
      'Take a break every 25 minutes of work',
      'Try to walk 10,000 steps daily',
      'Dedicate 7-8 hours to sleep each night',
      'Eat 5 servings of fruits and vegetables daily',
    ];

    final randomTip = tips[DateTime.now().millisecond % tips.length];

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 10),
        ],
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lightbulb, color: Colors.blue.shade800),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tip of the Day',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(randomTip),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

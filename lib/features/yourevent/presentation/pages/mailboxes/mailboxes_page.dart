// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/data/models/event_model.dart';
import '../../cubits/events/events_cubit.dart';
import '../../cubits/events/events_state.dart';
import '../tasks/edit_task_page.dart';
import '../tasks/task_detail_page.dart';

class MailboxesPage extends StatefulWidget {
  const MailboxesPage({super.key});
  static const String id = 'mailboxes_page';

  @override
  State<MailboxesPage> createState() => _MailboxesPageState();
}

class _MailboxesPageState extends State<MailboxesPage> {
  List<EventModel> _allTasks = [];
  List<EventModel> _todayTasks = [];
  List<EventModel> _upcomingTasks = [];
  List<EventModel> _sportsTasks = [];
  List<EventModel> _workTasks = [];
  List<EventModel> _funTasks = [];

  @override
  void initState() {
    super.initState();
    context.read<EventsCubit>().loadEvents();
  }

  void _filterTasks(List<EventModel> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    setState(() {
      _allTasks = tasks;

      _todayTasks = tasks.where((task) {
        final taskDate = DateTime(
          task.eventDate.year,
          task.eventDate.month,
          task.eventDate.day,
        );
        return taskDate.isAtSameMomentAs(today);
      }).toList();

      _upcomingTasks = tasks.where((task) {
        final taskDate = DateTime(
          task.eventDate.year,
          task.eventDate.month,
          task.eventDate.day,
        );
        return taskDate.isAfter(today);
      }).toList();

      // Filter by categories (using task icon for demo purposes)
      _sportsTasks = tasks
          .where(
            (task) =>
                task.icon == 'sports' ||
                task.description.toLowerCase().contains('sport'),
          )
          .toList();
      _workTasks = tasks
          .where(
            (task) =>
                task.icon == 'work' ||
                task.description.toLowerCase().contains('work'),
          )
          .toList();
      _funTasks = tasks
          .where(
            (task) =>
                task.icon == 'holiday' ||
                task.description.toLowerCase().contains('fun'),
          )
          .toList();
    });
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
            _filterTasks(state.events);
          }
        },
        builder: (context, state) {
          if (state.status == EventsStatus.loading && state.events.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Today section
              _buildCategoryHeader(context, 'Today', _todayTasks.length),
              _buildMailboxItem(
                context,
                'Today',
                Icons.today,
                Colors.blue,
                _todayTasks.length,
                () => _showTasksDialog('Today', _todayTasks),
              ),

              const SizedBox(height: 8),

              // Upcoming section
              _buildCategoryHeader(context, 'Upcoming', _upcomingTasks.length),
              _buildMailboxItem(
                context,
                'Upcoming',
                Icons.event,
                Colors.orange,
                _upcomingTasks.length,
                () => _showTasksDialog('Upcoming', _upcomingTasks),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Categories section
              _buildCategoryHeader(context, 'Categories', _allTasks.length),

              _buildMailboxItem(
                context,
                'Sports',
                Icons.sports,
                Colors.green,
                _sportsTasks.length,
                () => _showTasksDialog('Sports', _sportsTasks),
              ),

              _buildMailboxItem(
                context,
                'Work',
                Icons.work,
                Colors.purple,
                _workTasks.length,
                () => _showTasksDialog('Work', _workTasks),
              ),

              _buildMailboxItem(
                context,
                'Fun',
                Icons.beach_access,
                Colors.pink,
                _funTasks.length,
                () => _showTasksDialog('Fun', _funTasks),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Settings
              _buildMailboxItem(
                context,
                'Settings',
                Icons.settings,
                Colors.grey,
                0,
                () {},
                showCount: false,
              ),
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

  Widget _buildCategoryHeader(BuildContext context, String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (count > 0)
            Text(
              count.toString(),
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMailboxItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    int count,
    VoidCallback onTap, {
    bool showCount = true,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: showCount && count > 0
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
  }

  void _showTasksDialog(String title, List<EventModel> tasks) {
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
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              if (tasks.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('No tasks available')),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return _buildTaskItem(tasks[index]);
                    },
                  ),
                ),
            ],
          ),
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

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: priorityColor, shape: BoxShape.circle),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          color: task.isCompleted ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Text(
        task.description.isNotEmpty ? task.description : 'No description',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Checkbox(
        value: task.isCompleted,
        activeColor: Theme.of(context).primaryColor,
        onChanged: (value) {
          if (value != null) {
            context.read<EventsCubit>().markEventAsCompleted(task.id, value);
          }
        },
      ),
      onTap: () {
        Navigator.pop(context);
        _navigateToTaskDetail(task);
      },
    );
  }
}

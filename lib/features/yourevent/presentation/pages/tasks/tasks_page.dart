// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../../core/data/models/event_model.dart';
import '../../cubits/events/events_cubit.dart';
import '../../cubits/events/events_state.dart';
import 'edit_task_page.dart';
import 'task_detail_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<EventModel> _todayTasks = [];
  List<EventModel> _inboxTasks = [];
  List<EventModel> _upcomingTasks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load events
    context.read<EventsCubit>().loadEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  void _navigateToTaskDetail(EventModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailPage(task: task)),
    );
  }

  void _filterTasks(List<EventModel> allTasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    setState(() {
      _todayTasks = allTasks.where((task) {
        final taskDate = DateTime(
          task.eventDate.year,
          task.eventDate.month,
          task.eventDate.day,
        );
        return taskDate.isAtSameMomentAs(today);
      }).toList();

      _inboxTasks = allTasks;

      _upcomingTasks = allTasks.where((task) {
        final taskDate = DateTime(
          task.eventDate.year,
          task.eventDate.month,
          task.eventDate.day,
        );
        return taskDate.isAfter(today);
      }).toList();
    });
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

          return SafeArea(
            child: Column(children: [Gap(16), _buildTasksList()]),
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

  Widget _buildTasksList() {
    return Expanded(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                const Tab(text: 'Today'),
                const Tab(text: 'Inbox'),
                const Tab(text: 'Upcoming'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTasksListView(_todayTasks, 'No tasks for today'),
                  _buildTasksListView(_inboxTasks, 'No tasks available'),
                  _buildTasksListView(_upcomingTasks, 'No upcoming tasks'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksListView(List<EventModel> tasks, String emptyMessage) {
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskItem(task);
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
                // Priority indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: priorityColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const Gap(16),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../../core/data/models/event_model.dart';
import '../../cubits/events/events_cubit.dart';
import 'edit_task_page.dart';

class TaskDetailPage extends StatelessWidget {
  final EventModel task;

  const TaskDetailPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // Get priority color
    Color priorityColor;
    String priorityText;

    switch (task.color) {
      case '0xFFFF0000': // Red
        priorityColor = Colors.red;
        priorityText = 'High';
        break;
      case '0xFFFFAA00': // Orange/Yellow
        priorityColor = Colors.orange;
        priorityText = 'Medium';
        break;
      default:
        priorityColor = Colors.green;
        priorityText = 'Low';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditTask(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task title and completion status
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                Checkbox(
                  value: task.isCompleted,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<EventsCubit>().markEventAsCompleted(
                            task.id,
                            value,
                          );
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ],
            ),

            const Divider(height: 32),

            // Task metadata
            _buildInfoRow(
              context,
              Icons.calendar_today,
              DateFormat('EEEE, MMM dd, yyyy').format(task.eventDate),
            ),

            const Gap(16),

            _buildInfoRow(
              context,
              Icons.access_time,
              DateFormat('h:mm a').format(task.eventDate),
            ),

            const Gap(16),

            _buildInfoRow(
              context,
              Icons.flag,
              priorityText,
              color: priorityColor,
            ),

            if (task.description.isNotEmpty) ...[
              const Divider(height: 32),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Gap(12),
              Text(task.description, style: const TextStyle(fontSize: 16)),
            ],

            const Divider(height: 32),

            // Task history/activity
            const Text(
              'Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Gap(12),

            _buildActivityItem(
              'Created',
              DateFormat('MMM dd, yyyy - h:mm a').format(task.createdAt),
            ),

            if (task.updatedAt != task.createdAt)
              _buildActivityItem(
                'Last modified',
                DateFormat('MMM dd, yyyy - h:mm a').format(task.updatedAt),
              ),

            if (task.isCompleted)
              _buildActivityItem('Completed', 'Task marked as completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String text, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color ?? Colors.grey[700]),
        const Gap(16),
        Text(
          text,
          style: TextStyle(fontSize: 16, color: color ?? Colors.black),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Gap(4),
                Text(description, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditTask(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTaskPage(task: task)),
    );

    if (result == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _deleteTask(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTask(BuildContext context) async {
    try {
      await context.read<EventsCubit>().deleteEvent(task.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete task: $e')));
      }
    }
  }
}

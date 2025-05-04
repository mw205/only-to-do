// lib/presentation/pages/events/event_details_page.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../core/data/models/event_model.dart';
import '../../cubits/events/events_cubit.dart';
import '../../widgets/countdown_timer.dart';
import 'add_edit_event_page.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;
  static const String id = 'event_details_page';

  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final colorValue = event.color != null
        ? int.tryParse(event.color!) ?? 0xFF6200EE
        : 0xFF6200EE;
    final eventColor = Color(colorValue);

    final isExpired = event.eventDate.isBefore(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareEvent(context),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditEvent(context),
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
            // Event header with title and icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: eventColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconData(event.icon),
                    color: eventColor,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            DateFormat(
                              'MMM dd, yyyy - h:mm a',
                            ).format(event.eventDate),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (event.isCompleted) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Completed',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ] else if (isExpired) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Expired',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Countdown timer (if not completed and not expired)
            if (!isExpired && !event.isCompleted) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: eventColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Time Remaining',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: eventColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CountdownTimer(
                      targetDate: event.eventDate,
                      backgroundColor: Colors.transparent,
                      foregroundColor: eventColor,
                      digitStyle: TextStyle(
                        color: eventColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      labelStyle: TextStyle(
                        color: eventColor.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Description section
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                event.description.isNotEmpty
                    ? event.description
                    : 'No description provided',
                style: TextStyle(
                  fontSize: 16,
                  color: event.description.isNotEmpty
                      ? Colors.black87
                      : Colors.grey,
                  fontStyle: event.description.isNotEmpty
                      ? FontStyle.normal
                      : FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Reminders section
            const Text(
              'Reminders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (event.reminderTimes.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'No reminders set for this event',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              Column(
                children: event.reminderTimes.map((reminderTime) {
                  final isPast = reminderTime.isBefore(DateTime.now());

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isPast
                          ? Colors.grey[100]
                          : eventColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: isPast
                          ? Border.all(color: Colors.grey[300]!)
                          : Border.all(
                              color: eventColor.withValues(alpha: 0.3),
                            ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: isPast ? Colors.grey : eventColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat(
                                  'EEEE, MMM dd, yyyy - h:mm a',
                                ).format(reminderTime),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isPast ? Colors.grey : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatReminderTime(
                                  event.eventDate,
                                  reminderTime,
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isPast ? Colors.grey : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isPast)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Past',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 32),

            // Mark as completed button
            if (!event.isCompleted)
              ElevatedButton.icon(
                onPressed: () => _markAsCompleted(context, true),
                icon: const Icon(Icons.check_circle),
                label: const Text('Mark as Completed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              )
            else
              OutlinedButton.icon(
                onPressed: () => _markAsCompleted(context, false),
                icon: const Icon(Icons.cancel),
                label: const Text('Mark as Incomplete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Format reminder time as relative to event date
  String _formatReminderTime(DateTime eventDate, DateTime reminderTime) {
    final difference = eventDate.difference(reminderTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} before the event';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} before the event';
    } else {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} before the event';
    }
  }

  // Navigate to edit event page
  void _navigateToEditEvent(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditEventPage(event: event)),
    );

    if (result == true) {
      if (!context.mounted) return;
      Navigator.pop(context, true); // Refresh previous page
    }
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _deleteEvent(context);
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

  // Delete event
  void _deleteEvent(BuildContext context) async {
    try {
      await context.read<EventsCubit>().deleteEvent(event.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event deleted successfully')),
        );
        Navigator.pop(context, true); // Refresh previous page
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete event: $e')));
      }
    }
  }

  // Mark event as completed or incomplete
  void _markAsCompleted(BuildContext context, bool isCompleted) async {
    try {
      await context.read<EventsCubit>().markEventAsCompleted(
            event.id,
            isCompleted,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCompleted
                  ? 'Event marked as completed'
                  : 'Event marked as incomplete',
            ),
          ),
        );
        Navigator.pop(context, true); // Refresh previous page
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update event: $e')));
      }
    }
  }

  // Share event details
  void _shareEvent(BuildContext context) {
    final formattedDate = DateFormat(
      'EEEE, MMMM d, yyyy - h:mm a',
    ).format(event.eventDate);

    final message = '''
Event: ${event.title}
Date: $formattedDate
${event.description.isNotEmpty ? '\nDescription: ${event.description}' : ''}

Shared from Event Countdown App
''';

    Share.share(message, subject: 'Event Details: ${event.title}');
  }

  // Get icon data from string
  IconData _getIconData(String? iconName) {
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

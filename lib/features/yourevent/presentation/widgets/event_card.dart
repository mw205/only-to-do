import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/data/models/event_model.dart';
import 'countdown_timer.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onCompleted;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.onDelete,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final colorValue = event.color != null
        ? int.tryParse(event.color!) ?? 0xFF6200EE
        : 0xFF6200EE;
    final eventColor = Color(colorValue);

    final isExpired = event.eventDate.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: event.isCompleted
              ? Colors.green
              : (isExpired ? Colors.red : eventColor),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: eventColor.withValues(alpha: .1),
              child: Row(
                children: [
                  Icon(_getIconData(event.icon), color: eventColor, size: 30),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat(
                            'MMM dd, yyyy - h:mm a',
                          ).format(event.eventDate),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onCompleted != null)
                    Checkbox(
                      value: event.isCompleted,
                      onChanged: (value) {
                        if (value != null) {
                          onCompleted!(value);
                        }
                      },
                      activeColor: Colors.green,
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.description.isNotEmpty) ...[
                    Text(
                      event.description,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (!isExpired && !event.isCompleted)
                    CountdownTimer(
                      targetDate: event.eventDate,
                      digitStyle: TextStyle(
                        color: eventColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      labelStyle: TextStyle(
                        color: eventColor.withValues(alpha: .7),
                        fontSize: 10,
                      ),
                    )
                  else if (isExpired)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Event Expired',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (onDelete != null)
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
              ),
          ],
        ),
      ),
    );
  }

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

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationSettings extends StatefulWidget {
  final bool enableEventReminders;
  final bool enablePomodoroReminders;
  final bool enableDailyReminders;
  final Function(bool) onEventRemindersChanged;
  final Function(bool) onPomodoroRemindersChanged;
  final Function(bool) onDailyRemindersChanged;

  const NotificationSettings({
    super.key,
    required this.enableEventReminders,
    required this.enablePomodoroReminders,
    required this.enableDailyReminders,
    required this.onEventRemindersChanged,
    required this.onPomodoroRemindersChanged,
    required this.onDailyRemindersChanged,
  });

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Gap(8),
                const Text(
                  'Notification Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Gap(16),
            const Text(
              'Configure which notifications you want to receive:',
              style: TextStyle(color: Colors.grey),
            ),
            const Gap(16),

            // Event reminders
            SwitchListTile(
              title: const Text('Event Reminders'),
              subtitle: const Text('Notifications for upcoming events'),
              value: widget.enableEventReminders,
              onChanged: widget.onEventRemindersChanged,
              activeColor: Theme.of(context).colorScheme.primary,
              contentPadding: EdgeInsets.zero,
            ),

            const Divider(),

            // Pomodoro reminders
            SwitchListTile(
              title: const Text('Pomodoro Notifications'),
              subtitle: const Text('Alerts for focus and break sessions'),
              value: widget.enablePomodoroReminders,
              onChanged: widget.onPomodoroRemindersChanged,
              activeColor: Theme.of(context).colorScheme.primary,
              contentPadding: EdgeInsets.zero,
            ),

            const Divider(),

            // Daily reminders
            SwitchListTile(
              title: const Text('Daily Reminders'),
              subtitle: const Text('Reminders for daily tracking and habits'),
              value: widget.enableDailyReminders,
              onChanged: widget.onDailyRemindersChanged,
              activeColor: Theme.of(context).colorScheme.primary,
              contentPadding: EdgeInsets.zero,
            ),

            const Gap(8),

            // Help text
            Text(
              'Note: You can also configure reminder times for individual events.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

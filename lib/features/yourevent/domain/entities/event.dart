// lib/domain/entities/event.dart
import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final List<DateTime> reminderTimes;
  final String userId;
  final bool isCompleted;
  final String? color;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.reminderTimes,
    required this.userId,
    this.isCompleted = false,
    this.color,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a copy with specified attributes changed
  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? eventDate,
    List<DateTime>? reminderTimes,
    String? userId,
    bool? isCompleted,
    String? color,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      reminderTimes: reminderTimes ?? this.reminderTimes,
      userId: userId ?? this.userId,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if event is past due
  bool get isPastDue => DateTime.now().isAfter(eventDate) && !isCompleted;

  // Get time remaining until event
  Duration get timeRemaining => eventDate.difference(DateTime.now());

  // Get closest reminder time that hasn't passed yet
  DateTime? get nextReminderTime {
    final now = DateTime.now();
    final upcomingReminders =
        reminderTimes.where((reminder) => reminder.isAfter(now)).toList()
          ..sort();

    return upcomingReminders.isEmpty ? null : upcomingReminders.first;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    eventDate,
    reminderTimes,
    userId,
    isCompleted,
    color,
    icon,
    createdAt,
    updatedAt,
  ];
}

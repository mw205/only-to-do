import 'package:equatable/equatable.dart';

class DailyTracker extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final int completedEvents;
  final int totalEvents;
  final int completedPomodoroSessions;
  final int sleepHours;
  final bool dietTracked;
  final int waterIntake; // in milliliters
  final int steps;
  final List<String> completedTasks;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DailyTracker({
    required this.id,
    required this.userId,
    required this.date,
    this.completedEvents = 0,
    this.totalEvents = 0,
    this.completedPomodoroSessions = 0,
    this.sleepHours = 0,
    this.dietTracked = false,
    this.waterIntake = 0,
    this.steps = 0,
    this.completedTasks = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a copy with specified attributes changed
  DailyTracker copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? completedEvents,
    int? totalEvents,
    int? completedPomodoroSessions,
    int? sleepHours,
    bool? dietTracked,
    int? waterIntake,
    int? steps,
    List<String>? completedTasks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyTracker(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      completedEvents: completedEvents ?? this.completedEvents,
      totalEvents: totalEvents ?? this.totalEvents,
      completedPomodoroSessions:
          completedPomodoroSessions ?? this.completedPomodoroSessions,
      sleepHours: sleepHours ?? this.sleepHours,
      dietTracked: dietTracked ?? this.dietTracked,
      waterIntake: waterIntake ?? this.waterIntake,
      steps: steps ?? this.steps,
      completedTasks: completedTasks ?? this.completedTasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Calculate event completion percentage
  double get eventCompletionPercentage {
    if (totalEvents == 0) return 0.0;
    return (completedEvents / totalEvents) * 100;
  }

  // Calculate water intake in cups (1 cup = 240 ml)
  double get waterIntakeInCups {
    return waterIntake / 240;
  }

  // Calculate step goal progress (assuming 10,000 steps daily goal)
  double get stepGoalProgress {
    return steps / 10000;
  }

  // Check if this tracker is for today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    date,
    completedEvents,
    totalEvents,
    completedPomodoroSessions,
    sleepHours,
    dietTracked,
    waterIntake,
    steps,
    completedTasks,
    createdAt,
    updatedAt,
  ];
}

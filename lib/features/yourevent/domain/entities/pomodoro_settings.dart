import 'package:equatable/equatable.dart';

class PomodoroSettings extends Equatable {
  final int focusDuration; // in minutes
  final int shortBreakDuration; // in minutes
  final int longBreakDuration; // in minutes
  final int longBreakAfter; // after how many sessions
  final int targetSessions;
  final bool autoStartBreaks;
  final bool autoStartPomodoros;
  final String userId;

  const PomodoroSettings({
    this.focusDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.longBreakAfter = 4,
    this.targetSessions = 8,
    this.autoStartBreaks = true,
    this.autoStartPomodoros = false,
    required this.userId,
  });

  // Create a copy with specified attributes changed
  PomodoroSettings copyWith({
    int? focusDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? longBreakAfter,
    int? targetSessions,
    bool? autoStartBreaks,
    bool? autoStartPomodoros,
    String? userId,
  }) {
    return PomodoroSettings(
      focusDuration: focusDuration ?? this.focusDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      longBreakAfter: longBreakAfter ?? this.longBreakAfter,
      targetSessions: targetSessions ?? this.targetSessions,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartPomodoros: autoStartPomodoros ?? this.autoStartPomodoros,
      userId: userId ?? this.userId,
    );
  }

  // Get break duration based on completed sessions
  int getBreakDuration(int completedSessions) {
    return completedSessions % longBreakAfter == 0 && completedSessions > 0
        ? longBreakDuration
        : shortBreakDuration;
  }

  @override
  List<Object?> get props => [
    focusDuration,
    shortBreakDuration,
    longBreakDuration,
    longBreakAfter,
    targetSessions,
    autoStartBreaks,
    autoStartPomodoros,
    userId,
  ];
}

import 'package:equatable/equatable.dart';

enum PomodoroStatus { initial, running, paused, completed, breakTime }

class PomodoroState extends Equatable {
  final int focusDuration; // in minutes
  final int shortBreakDuration; // in minutes
  final int longBreakDuration; // in minutes
  final int longBreakAfter; // after how many sessions

  final PomodoroStatus status;
  final int remainingSeconds;
  final int completedSessions;
  final int targetSessions;
  final bool isBreak;

  const PomodoroState({
    this.focusDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.longBreakAfter = 4,
    this.status = PomodoroStatus.initial,
    this.remainingSeconds = 0,
    this.completedSessions = 0,
    this.targetSessions = 4,
    this.isBreak = false,
  });

  // Initial state with default values
  factory PomodoroState.initial() {
    return PomodoroState(
      remainingSeconds: 25 * 60, // 25 minutes in seconds
    );
  }

  // Create a copy with specified attributes changed
  PomodoroState copyWith({
    int? focusDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? longBreakAfter,
    PomodoroStatus? status,
    int? remainingSeconds,
    int? completedSessions,
    int? targetSessions,
    bool? isBreak,
  }) {
    return PomodoroState(
      focusDuration: focusDuration ?? this.focusDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      longBreakAfter: longBreakAfter ?? this.longBreakAfter,
      status: status ?? this.status,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      completedSessions: completedSessions ?? this.completedSessions,
      targetSessions: targetSessions ?? this.targetSessions,
      isBreak: isBreak ?? this.isBreak,
    );
  }

  @override
  List<Object?> get props => [
    focusDuration,
    shortBreakDuration,
    longBreakDuration,
    longBreakAfter,
    status,
    remainingSeconds,
    completedSessions,
    targetSessions,
    isBreak,
  ];
}

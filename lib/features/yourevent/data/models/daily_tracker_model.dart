import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DailyTrackerModel extends Equatable {
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

  const DailyTrackerModel({
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

  // Convert Firestore document to DailyTrackerModel
  factory DailyTrackerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyTrackerModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      completedEvents: data['completedEvents'] ?? 0,
      totalEvents: data['totalEvents'] ?? 0,
      completedPomodoroSessions: data['completedPomodoroSessions'] ?? 0,
      sleepHours: data['sleepHours'] ?? 0,
      dietTracked: data['dietTracked'] ?? false,
      waterIntake: data['waterIntake'] ?? 0,
      steps: data['steps'] ?? 0,
      completedTasks: List<String>.from(data['completedTasks'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Convert DailyTrackerModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'completedEvents': completedEvents,
      'totalEvents': totalEvents,
      'completedPomodoroSessions': completedPomodoroSessions,
      'sleepHours': sleepHours,
      'dietTracked': dietTracked,
      'waterIntake': waterIntake,
      'steps': steps,
      'completedTasks': completedTasks,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create a copy with specified attributes changed
  DailyTrackerModel copyWith({
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
    return DailyTrackerModel(
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

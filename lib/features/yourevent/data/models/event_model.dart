import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
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

  const EventModel({
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

  // Convert Firestore document to EventModel
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      eventDate: (data['eventDate'] as Timestamp).toDate(),
      reminderTimes:
          (data['reminderTimes'] as List<dynamic>)
              .map((time) => (time as Timestamp).toDate())
              .toList(),
      userId: data['userId'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      color: data['color'],
      icon: data['icon'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Convert EventModel to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'eventDate': Timestamp.fromDate(eventDate),
      'reminderTimes':
          reminderTimes.map((time) => Timestamp.fromDate(time)).toList(),
      'userId': userId,
      'isCompleted': isCompleted,
      'color': color,
      'icon': icon,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create a copy of EventModel with specified attributes changed
  EventModel copyWith({
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
    return EventModel(
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

import '../entities/event.dart';

abstract class EventUseCases {
  /// Get all events for the current user
  Stream<List<Event>> getEvents();

  /// Get upcoming events (events that haven't passed yet)
  Stream<List<Event>> getUpcomingEvents();

  /// Get an event by ID
  Future<Event?> getEventById(String eventId);

  /// Add a new event
  Future<String> addEvent(Event event);

  /// Update an existing event
  Future<void> updateEvent(Event event);

  /// Delete an event
  Future<void> deleteEvent(String eventId);

  /// Mark an event as completed or not completed
  Future<void> markEventAsCompleted(String eventId, bool isCompleted);

  /// Get events for a specific date
  Stream<List<Event>> getEventsForDate(DateTime date);
}

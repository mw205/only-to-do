import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';
import '../entities/event.dart';
import 'event_usecases.dart';

class EventUseCasesImpl implements EventUseCases {
  final EventRepository _eventRepository;

  EventUseCasesImpl(this._eventRepository);

  // Helper method to convert EventModel to Event entity
  Event _mapModelToEntity(EventModel model) {
    return Event(
      id: model.id,
      title: model.title,
      description: model.description,
      eventDate: model.eventDate,
      reminderTimes: model.reminderTimes,
      userId: model.userId,
      isCompleted: model.isCompleted,
      color: model.color,
      icon: model.icon,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  // Helper method to convert Event entity to EventModel
  EventModel _mapEntityToModel(Event entity) {
    return EventModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      eventDate: entity.eventDate,
      reminderTimes: entity.reminderTimes,
      userId: entity.userId,
      isCompleted: entity.isCompleted,
      color: entity.color,
      icon: entity.icon,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Stream<List<Event>> getEvents() {
    return _eventRepository.getEvents().map(
      (modelsList) => modelsList.map(_mapModelToEntity).toList(),
    );
  }

  @override
  Stream<List<Event>> getUpcomingEvents() {
    return _eventRepository.getUpcomingEvents().map(
      (modelsList) => modelsList.map(_mapModelToEntity).toList(),
    );
  }

  @override
  Future<Event?> getEventById(String eventId) async {
    final eventModel = await _eventRepository.getEventById(eventId);
    if (eventModel == null) return null;
    return _mapModelToEntity(eventModel);
  }

  @override
  Future<String> addEvent(Event event) async {
    final eventModel = _mapEntityToModel(event);
    return await _eventRepository.addEvent(eventModel);
  }

  @override
  Future<void> updateEvent(Event event) async {
    final eventModel = _mapEntityToModel(event);
    await _eventRepository.updateEvent(eventModel);
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await _eventRepository.deleteEvent(eventId);
  }

  @override
  Future<void> markEventAsCompleted(String eventId, bool isCompleted) async {
    await _eventRepository.markEventAsCompleted(eventId, isCompleted);
  }

  @override
  Stream<List<Event>> getEventsForDate(DateTime date) {
    // Get all events and filter by date
    return getEvents().map((events) {
      return events.where((event) {
        final eventDate = DateTime(
          event.eventDate.year,
          event.eventDate.month,
          event.eventDate.day,
        );
        final targetDate = DateTime(date.year, date.month, date.day);
        return eventDate.isAtSameMomentAs(targetDate);
      }).toList();
    });
  }
}

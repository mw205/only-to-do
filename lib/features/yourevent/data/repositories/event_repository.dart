import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';
import '../../services/firebase_service.dart';

class EventRepository {
  final FirebaseService _firebaseService = FirebaseService();

  // Reference to events collection
  CollectionReference get _eventsCollection =>
      _firebaseService.firestore.collection('events');

  // Get all events for current user
  Stream<List<EventModel>> getEvents() {
    final userId = _firebaseService.currentUserId;
    if (userId == null) return Stream.value([]);

    return _eventsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('eventDate')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => EventModel.fromFirestore(doc))
                  .toList(),
        );
  }

  // Get upcoming events (events that haven't passed yet)
  Stream<List<EventModel>> getUpcomingEvents() {
    final userId = _firebaseService.currentUserId;
    if (userId == null) return Stream.value([]);

    final now = DateTime.now();

    return _eventsCollection
        .where('userId', isEqualTo: userId)
        .where('eventDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('eventDate')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => EventModel.fromFirestore(doc))
                  .toList(),
        );
  }

  // Get single event by ID
  Future<EventModel?> getEventById(String eventId) async {
    final doc = await _eventsCollection.doc(eventId).get();
    if (!doc.exists) return null;
    return EventModel.fromFirestore(doc);
  }

  // Add new event
  Future<String> addEvent(EventModel event) async {
    final now = DateTime.now();
    final newEvent = event.copyWith(createdAt: now, updatedAt: now);

    final docRef = await _eventsCollection.add(newEvent.toFirestore());
    return docRef.id;
  }

  // Update existing event
  Future<void> updateEvent(EventModel event) async {
    final updatedEvent = event.copyWith(updatedAt: DateTime.now());

    await _eventsCollection.doc(event.id).update(updatedEvent.toFirestore());
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await _eventsCollection.doc(eventId).delete();
  }

  // Mark event as completed
  Future<void> markEventAsCompleted(String eventId, bool isCompleted) async {
    await _eventsCollection.doc(eventId).update({
      'isCompleted': isCompleted,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }
}

import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/models/event_notification.dart';
import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/models/schedule.dart';
import 'package:app_tcc/models/schedule_time.dart';
import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/models/user.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/restaurants/restaurants_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/transformers.dart';

class UserDataRepository {
  final AuthRepository _auth = inject();
  final RestaurantsRepository _restaurantsRepository = inject();
  final Firestore _store = inject();

  Future<DocumentReference> get userDocument async {
    final user = await _auth.currentUser;
    return _store.collection('users').document(user.uid);
  }

  Future<CollectionReference> collection(String name) async {
    return (await userDocument).collection(name);
  }

  Future<CollectionReference> get _subjectsCollection => collection('subjects');

  Future<CollectionReference> get _eventsCollection => collection('events');

  Future<CollectionReference> get _notificationsCollection =>
      collection('notifications');

  Stream<Settings> get settingsStream async* {
    final document = await userDocument;
    yield* document.snapshots().map((s) {
      final data = s.data ?? {};
      final defaultValues = <String, dynamic>{
        'allowNotifications': true,
        'connected': false
      };
      final json = Map<String, dynamic>.from(data['settings'] ?? {});
      defaultValues.addAll(json);
      return Settings.fromJson(Map<String, dynamic>.from(defaultValues));
    });
  }

  Future<Settings> get settings => settingsStream.first;

  Stream<List<Event>> get eventsStream async* {
    yield* (await _eventsCollection)
        .where("date", isGreaterThan: DateTime.now())
        .orderBy("date")
        .snapshots()
        .map((snapshot) =>
            snapshot.documents.map((d) => Event.fromJson(d.data)).toList());
  }

  Stream<List<EventNotification>> get notificationsStream async* {
    yield* (await _notificationsCollection).snapshots().map((snapshot) =>
        snapshot.documents
            .map((d) => EventNotification.fromJson(d.data)
                .rebuild((b) => b..documentID = d.documentID))
            .toList());
  }

  Stream<List<Subject>> get subjectsStream async* {
    yield* (await _subjectsCollection).snapshots().map((snapshot) => snapshot
        .documents
        .map((d) => Subject.fromJson(d.data)
            .rebuild((b) => b..documentID = d.documentID))
        .toList());
  }

  Stream<List<Schedule>> get schedulesStream => subjectsStream.map((subjects) {
        final schedules =
            List<Schedule>.generate(7, (i) => Schedule(Day(i + 1)));
        subjects.forEach((sj) {
          sj.times.forEach((t) {
            final schedule = schedules.firstWhere(
              (s) => s.weekDay.value == t.dayOfTheWeek.value,
            );
            schedule.times.add(ScheduleTime(
              time: t.time,
              subject: sj,
            ));
          });
        });
        return schedules;
      });

  Future<List<Subject>> get subjects => subjectsStream.first;

  Stream<Restaurant> get restaurantStream {
    return settingsStream
        .transform(FlatMapStreamTransformer((settings) =>
            _restaurantsRepository.restaurant(settings.restaurantId)))
        .map((restaurant) {
      if (restaurant == null) return null;
      return restaurant.rebuild((b) {
        final limitDate = DateTime.now().subtract(Duration(days: 1));
        return b
          ..menu.sort((a, b) => a.date.compareTo(b.date))
          ..menu.removeWhere((m) => m.date.isBefore(limitDate))
          ..menuDinner.sort((a, b) => a.date.compareTo(b.date))
          ..menuDinner.removeWhere((m) => m.date.isBefore(limitDate));
      });
    });
  }

  Future<void> saveSettings(Settings settings) async {
    (await userDocument).setData(
      {"settings": settings.toJson()},
      merge: true,
    );
  }

  Future<void> saveSubject(Subject subject) async {
    (await _subjectsCollection)
        .document(subject.documentID)
        .setData(subject.toJson());
  }

  Future<void> createEvent(Event event) async {
    (await _eventsCollection).add(event.toJson());
  }

  Future<User> get currentUser async {
    final user = await _auth.currentUser;
    return User((b) => b..email = user?.email ?? "");
  }

  Future<void> replaceSubjects(List<Subject> subjects) async {
    final collection = await _subjectsCollection;
    (await collection.getDocuments())
        .documents
        .forEach((d) async => await d.reference.delete());
    subjects.forEach((s) async => await collection.add(s.toJson()));
  }

  Future<void> removeNotification(EventNotification notification) async {
    final collection = await _notificationsCollection;
    collection.document(notification.documentID).delete();
  }

  Future<void> updateNotificationsToken(String token) async {
    (await userDocument).setData(
      {"notificationsToken": token},
      merge: true,
    );
  }
}

import 'package:app_tcc/models/day.dart';
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
import 'package:firebase/firestore.dart' as fs;
import 'package:rxdart/transformers.dart';

class UserDataRepository {
  final AuthRepository _auth = inject();
  final RestaurantsRepository _restaurantsRepository = inject();
  final fs.Firestore _store = inject();

  Future<fs.DocumentReference> get userDocument async {
    final user = await _auth.currentUser;
    return _store.collection('users').doc(user?.uid);
  }

  Future<fs.CollectionReference> collection(String name) async {
    return (await userDocument).collection(name);
  }

  Future<fs.CollectionReference> get _subjectsCollection =>
      collection('subjects');

  Future<fs.CollectionReference> get _eventsCollection => collection('events');

  Future<fs.CollectionReference> get _notificationsCollection =>
      collection('notifications');

  Stream<Settings> get settingsStream async* {
    final document = await userDocument;
    yield* document.onSnapshot.map((s) {
      final data = s.data() ?? {};
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
        .where("date", ">", DateTime.now())
        .orderBy("date")
        .onSnapshot
        .map((snapshot) => snapshot.docs
            .map((d) =>
                Event.fromJson(d.data()).rebuild((b) => b..documentId = d.id))
            .toList());
  }

  Stream<List<EventNotification>> get notificationsStream async* {
    yield* (await _notificationsCollection).onSnapshot.map((snapshot) =>
        snapshot.docs
            .map((d) => EventNotification.fromJson(d.data())
                .rebuild((b) => b..documentID = d.id))
            .toList());
  }

  Stream<List<Subject>> get subjectsStream async* {
    yield* (await _subjectsCollection).onSnapshot.map((snapshot) => snapshot
        .docs
        .map((d) =>
            Subject.fromJson(d.data()).rebuild((b) => b..documentID = d.id))
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
        schedules.forEach((s) {
          s.times.sort((a, b) => a.minutes - b.minutes);
        });
        return schedules;
      });

  Future<List<Schedule>> get schedules => schedulesStream.first;

  Future<List<Subject>> get subjects => subjectsStream.first;

  Stream<Restaurant> get restaurantStream {
    return settingsStream
        .transform(FlatMapStreamTransformer((settings) =>
            _restaurantsRepository.restaurant(settings.restaurantId)))
        .map((restaurant) {
      if (restaurant == null) return null;
      return restaurant.rebuild((b) {
        return b
          ..menu.sort((a, b) => a.date.compareTo(b.date))
          ..menuDinner.sort((a, b) => a.date.compareTo(b.date));
      });
    });
  }

  Future<void> saveSettings(Settings settings) async {
    (await userDocument).set(
      {"settings": settings.toJson()},
      fs.SetOptions(merge: true),
    );
  }

  Future<void> clearConnection() async {
    await saveSettings((await settings)..rebuild((b) => b.connected = false));
  }

  Future<void> saveInformation(Map<String, dynamic> information) async {
    (await userDocument).set({"information": information});
  }

  Future<void> saveSubject(Subject subject) async {
    (await _subjectsCollection).doc(subject.documentID).set(subject.toJson());
  }

  Future<void> createEvent(Event event) async {
    (await _eventsCollection).add(event.toJson());
  }

  Future<void> deleteEvent(String documentId) async {
    await (await _eventsCollection).doc(documentId).delete();
  }

  Future<User> get currentUser async {
    final user = await _auth.currentUser;
    return User((b) => b..email = user?.email ?? "");
  }

  Future<void> replaceSubjects(List<Subject> subjects) async {
    final collection = await _subjectsCollection;
    (await collection.onSnapshot.first)
        .docs
        .forEach((d) async => await d.ref.delete());
    subjects.forEach((s) async => await collection.add(s.toJson()));
  }

  Future<void> removeNotification(EventNotification notification) async {
    final collection = await _notificationsCollection;
    collection.doc(notification.documentID).delete();
  }

  Future<void> updateNotificationsToken(String token) async {
    (await userDocument).set(
      {"notificationsToken": token},
      fs.SetOptions(merge: true),
    );
  }
}

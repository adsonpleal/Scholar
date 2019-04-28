import 'package:app_tcc/models/event.dart';
import 'package:app_tcc/models/event_notification.dart';
import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/models/user.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataRepository {
  final AuthRepository _auth = inject();
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

  Future<Stream<Settings>> get settingsStream async {
    final document = await userDocument;
    return document.snapshots().map((s) {
      final data = s.data ?? {};
      final json = data['settings'] ?? {'allowNotifications': true};
      return Settings.fromJson(Map<String, dynamic>.from(json));
    });
  }

  Future<Stream<List<Event>>> get eventsStream async {
    return (await _eventsCollection)
        .where("date", isGreaterThan: DateTime.now())
        .orderBy("date")
        .snapshots()
        .map((snapshot) =>
            snapshot.documents.map((d) => Event.fromJson(d.data)).toList());
  }

  Future<Stream<List<EventNotification>>> get notificationsStream async {
    return (await _notificationsCollection).snapshots().map((snapshot) =>
        snapshot.documents
            .map((d) => EventNotification.fromJson(d.data)
                .rebuild((b) => b..documentID = d.documentID))
            .toList());
  }

  Future<Stream<List<Subject>>> get subjectsStream async {
    return (await _subjectsCollection).snapshots().map((snapshot) => snapshot
        .documents
        .map((d) => Subject.fromJson(d.data)
            .rebuild((b) => b..documentID = d.documentID))
        .toList());
  }

  Future<List<Subject>> get subjects async => (await subjectsStream).first;

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
    return User((b) => b..email = user.email);
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
}

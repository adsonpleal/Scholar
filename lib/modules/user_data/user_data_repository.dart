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

  get _subjectsCollections => collection('subjects');

  get _eventsCollections => collection('events');

  Future<Stream<Settings>> get settingsStream async {
    final document = await userDocument;
    return document.snapshots().map((s) {
      final data = Map<String, dynamic>.from(s.data['settings'] ?? {});
      return Settings.fromJson(data);
    });
  }

  Future<Stream<List<Subject>>> get subjectsStream async {
    return (await _subjectsCollections).snapshots().map((snapshot) => snapshot.documents
        .map((d) => Subject.fromJson(d.data).rebuild((b) => b..documentID = d.documentID))
        .toList());
  }

  Future<List<Subject>> get subjects async {
    final stream = await subjectsStream;
    return await stream.first;
  }

  Future<void> saveSettings(Settings settings) async {
    final document = await userDocument;
    await document.setData(
      {"settings": settings.toJson()},
      merge: true,
    );
  }

  Future<void> saveSubject(Subject subject) async {
    (await _subjectsCollections).document(subject.documentID).setData(subject.toJson());
  }

  Future<User> get currentUser async {
    final user = await _auth.currentUser;
    return User((b) => b..email = user.email);
  }

  Future<void> replaceSubjects(List<Subject> subjects) async {
    final collection = await _subjectsCollections;
    (await collection.getDocuments()).documents.forEach((d) async => await d.reference.delete());
    subjects.forEach((s) async => await collection.add(s.toJson()));
  }
}

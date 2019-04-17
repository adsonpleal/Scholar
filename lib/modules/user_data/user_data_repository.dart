import 'package:app_tcc/models/settings.dart';
import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/models/user.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataRepository {
  final AuthRepository _auth = inject();
  final Firestore _store = inject();

  Future<DocumentReference> getDocumment(String collection) async {
    final user = await _auth.currentUser;
    return _store.collection(collection).document(user.uid);
  }

  Future<DocumentReference> get _settingsDocumment => getDocumment("settings");
  Future<DocumentReference> get _ssubjectsDocumment => getDocumment("subjects");

  Future<Stream<Settings>> get settingsStream async {
    final document = await _settingsDocumment;
    return document.snapshots().map((s) => Settings.fromJson(s.data ?? {}));
  }

  Future<Stream<List<Subject>>> get subjectsStream async {
    final documment = await _ssubjectsDocumment;
    return documment.snapshots().map((s) {
      final values = ((s.data ?? {})["values"] ?? []).map((s) {
        s["times"] = s["times"].map((time) => Map<String, dynamic>.from(time)).toList();
        return Map<String, dynamic>.from(s);
      }).toList();
      return Subject.fromJsonList(values);
    });
  }

  Future<void> saveSettings(Settings settings) async {
    final document = await _settingsDocumment;
    await document.setData(settings.toJson());
  }

  Future<void> saveSubjects(List<Subject> subjects) async {
    final document = await _ssubjectsDocumment;
    await document
        .setData({"values": subjects.map((s) => s.toJson()).toList()});
  }

  Future<User> get currentUser async {
    final user = await _auth.currentUser;
    return User(email: user.email);
  }
}

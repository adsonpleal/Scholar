import 'package:app_tcc/models/settings.dart';
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

  Future<DocumentReference> get _userDocumment => getDocumment("users");

  Future<DocumentReference> get _settingsDocumment => getDocumment("settings");

  Future<Stream<User>> get userStream async {
    final document = await _userDocumment;
    return document.snapshots().map((s) => User.fromJson(s.data ?? {}));
  }

  Future<Stream<Settings>> get settingsStream async {
    final document = await _settingsDocumment;
    return document.snapshots().map((s) => Settings.fromJson(s.data ?? {}));
  }

  Future<void> saveUser(User user) async {
    final document = await _userDocumment;
    await document.setData(user.toJson());
  }

  Future<void> saveSettings(Settings settings) async {
    final document = await _settingsDocumment;
    await document.setData(settings.toJson());
  }
}

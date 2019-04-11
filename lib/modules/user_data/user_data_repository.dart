import 'package:app_tcc/models/user.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataRepository {
  final AuthRepository _auth = inject();
  final Firestore _store = inject();

  Future<DocumentReference> get _userDocumment async {
    final user = await _auth.currentUser;
    return _store.collection("users").document(user.uid);
  }

  Future<Stream<User>> get userStream async {
    final document = await _userDocumment;
    return document.snapshots().map((s) => User.fromJson(s.data));
  }

  Future<void> saveUser(User user) async {
    final document = await _userDocumment;
    await document.setData(user.toJson());
  }
}

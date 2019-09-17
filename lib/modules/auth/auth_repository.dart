import 'dart:async';

import 'package:firebase/firebase.dart' as fb;

class AuthRepository {
  final fb.Auth _firebaseAuth = fb.auth();

  Future<bool> get isLogged async {
    final user = await _firebaseAuth.onAuthStateChanged.first;
    return user != null;
  }

  Future<fb.User> get currentUser async => _firebaseAuth.currentUser;

  Future<String> signIn(String email, String password) async {
    fb.UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(email, password);
    return userCredential.user.uid;
  }

  Future<String> signUp(String email, String password) async {
    fb.UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(email, password);
    return userCredential.user.uid;
  }

  Future<void> resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    fb.User user = _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    fb.User user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }
}

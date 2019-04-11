import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/profile/link_repository.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements FirebaseUser {}

class MockUserDataRepository extends Mock implements UserDataRepository {}

class MockLinkRepository extends Mock implements LinkRepository {
  Stream<Uri> get uriLinksStream => Stream.empty();
}

class MockFirestore extends Mock implements Firestore {}

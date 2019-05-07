import 'dart:async';

import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/notifications/notifications_service.dart';
import 'package:app_tcc/modules/profile/link_repository.dart';
import 'package:app_tcc/modules/restaurants/restaurants_repository.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockNotificationsService extends Mock implements NotificationsService {}

class MockRestaurantsRepository extends Mock implements RestaurantsRepository {}

class MockUser extends Mock implements FirebaseUser {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserDataRepository extends Mock implements UserDataRepository {}

class MockLinkRepository extends Mock implements LinkRepository {
  Stream<Uri> get uriLinksStream => Stream.empty();
}

class MockFirestore extends Mock implements Firestore {}

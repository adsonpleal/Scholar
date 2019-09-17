import 'dart:async';

import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/restaurants/restaurants_repository.dart';
import 'package:app_tcc/modules/ufsc/ufsc_service.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:mockito/mockito.dart';

class MockRestaurantsRepository extends Mock implements RestaurantsRepository {}

class MockUser extends Mock implements User {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserDataRepository extends Mock implements UserDataRepository {}

class MockFirestore extends Mock implements Firestore {}

class MockUfscService extends Mock implements UfscService {}

import 'package:app_tcc/modules/base/module.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiwi/kiwi.dart';

class UserDataInjector {
  void configure() {
    final Container container = Container();
    container.registerSingleton((c) => Firestore.instance);
    container.registerSingleton((c) => UserDataRepository());
  }
}

class UserDataModule extends Module {
  @override
  void setup() {
    UserDataInjector().configure();
  }
}

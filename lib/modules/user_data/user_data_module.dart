import 'package:app_tcc/modules/base/module.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:firebase/firebase.dart';
import 'package:kiwi/kiwi.dart';

class UserDataInjector {
  void configure() {
    final Container container = Container();
    container.registerSingleton((c) => firestore());
    container.registerSingleton((c) => UserDataRepository());
  }
}

class UserDataModule extends Module {
  @override
  void setup() {
    UserDataInjector().configure();
  }
}

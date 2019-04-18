import 'package:app_tcc/modules/base/module.dart';
import 'package:kiwi/kiwi.dart';

import 'notifications_service.dart';

part 'notifications_module.g.dart';

abstract class NotificationInjector {
  @Register.factory(NotificationsService)
  void configure();
}

class NotificationModule extends Module {
  @override
  void setup() {
    var injector = _$NotificationInjector();
    injector.configure();
  }
}

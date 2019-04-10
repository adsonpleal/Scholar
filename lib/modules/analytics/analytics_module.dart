import 'package:app_tcc/modules/base/module.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:kiwi/kiwi.dart';

class AnalyticsInjector {
  void configure() {
    final Container container = Container();
    container.registerSingleton(
        (c) => FirebaseAnalyticsObserver(analytics: c<FirebaseAnalytics>()));
    container.registerSingleton((c) => FirebaseAnalytics());
  }
}

class AnalyticsModule extends Module {
  @override
  void setup() {
    AnalyticsInjector().configure();
  }
}

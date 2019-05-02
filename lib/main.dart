import 'package:app_tcc/modules/analytics/analytics_module.dart';
import 'package:app_tcc/modules/auth/auth_module.dart';
import 'package:app_tcc/modules/base/module.dart';
import 'package:app_tcc/modules/login/login_signup_module.dart';
import 'package:app_tcc/modules/login/login_signup_page.dart';
import 'package:app_tcc/modules/main/main_page.dart';
import 'package:app_tcc/modules/profile/profile_module.dart';
import 'package:app_tcc/modules/splash/splash_module.dart';
import 'package:app_tcc/modules/splash/splash_page.dart';
import 'package:app_tcc/modules/user_data/user_data_module.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/routes.dart' as Routes;
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'modules/agenda/agenda_module.dart';
import 'modules/home/home_module.dart';
import 'modules/new_event/new_event_module.dart';
import 'modules/new_event/new_event_page.dart';
import 'modules/notifications/notifications_module.dart';
import 'modules/restaurants/restaurants_module.dart';
import 'modules/ufsc/connect_ufsc_module.dart';
import 'modules/ufsc/connect_ufsc_page.dart';

class App extends StatelessWidget {
  final FirebaseAnalyticsObserver observer = inject();
  final List<Locale> supportedLocales;

  App(this.supportedLocales);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: Strings.appName,
        navigatorObservers: [
          observer,
        ],
        routes: {
          Routes.root: (c) => SplashPage(),
          Routes.login: (c) => LoginSignUpPage(),
          Routes.main: (c) => MainPage(),
          Routes.connectUfsc: (c) => ConnectUfscPage(),
          Routes.newEvent: (c) => NewEventPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        supportedLocales: supportedLocales,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      );
}

void main() {
  final supportedLocales = setupLocales();
  setupModules();
  runApp(App(
    supportedLocales,
  ));
}

List<Locale> setupLocales() {
  Intl.defaultLocale = 'pt';
  return [
    const Locale('pt'),
  ];
}

void setupModules() {
  <Module>[
    AuthModule(),
    AnalyticsModule(),
    UserDataModule(),
    SplashModule(),
    LoginSignUpModule(),
    ProfileModule(),
    ConnectUfscModule(),
    HomeModule(),
    NotificationModule(),
    AgendaModule(),
    NewEventModule(),
    RestaurantsModule(),
  ].forEach((module) => module.setup());
}

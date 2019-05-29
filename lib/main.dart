import 'package:app_tcc/modules/login/login_signup_page.dart';
import 'package:app_tcc/modules/main/main_page.dart';
import 'package:app_tcc/modules/splash/splash_page.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/routes.dart' as Routes;
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'modules/modules.dart';
import 'modules/new_event/new_event_page.dart';

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

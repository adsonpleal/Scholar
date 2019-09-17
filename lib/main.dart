import 'package:app_tcc/modules/login/login_signup_page.dart';
import 'package:app_tcc/modules/main/main_page.dart';
import 'package:app_tcc/modules/splash/splash_page.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/routes.dart' as Routes;
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'modules/event_details/event_details_page.dart';
import 'modules/modules.dart';
import 'modules/new_event/new_event_page.dart';

class App extends StatelessWidget {
  final List<Locale> supportedLocales;

  App(this.supportedLocales);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: Strings.appName,
      routes: {
        Routes.root: (c) => SplashPage(),
        Routes.login: (c) => LoginSignUpPage(),
        Routes.main: (c) => MainPage(),
        Routes.newEvent: (c) => NewEventPage(),
        Routes.eventDetails: (c) => EventPage(),
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
}

List<Locale> setupLocales() {
  Intl.defaultLocale = 'pt';
  return [
    const Locale('pt'),
  ];
}

void initFirebase() {
  initializeApp(
    apiKey: "AIzaSyBY5AB_c0AHnKcqonFFbWcVsJxNOVqHMeQ",
    authDomain: "adson-tcc.firebaseapp.com",
    databaseURL: "https://adson-tcc.firebaseio.com",
    projectId: "adson-tcc",
    storageBucket: "adson-tcc.appspot.com",
    messagingSenderId: "333894565881",
  );
}

Future main() async {
  setupModules();
  initFirebase();
  runApp(App(setupLocales()));
}

import 'package:app_tcc/modules/analytics/analytics_module.dart';
import 'package:app_tcc/modules/auth/auth_module.dart';
import 'package:app_tcc/modules/base/module.dart';
import 'package:app_tcc/modules/login/login_signup_module.dart';
import 'package:app_tcc/modules/login/login_signup_page.dart';
import 'package:app_tcc/modules/main/main_page.dart';
import 'package:app_tcc/modules/profile/profile_module.dart';
import 'package:app_tcc/modules/splash/splash_module.dart';
import 'package:app_tcc/modules/splash/splash_page.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/routes.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final FirebaseAnalyticsObserver observer = inject();

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
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ));
}

void main() {
  setupModules();
  runApp(App());
}

void setupModules() {
  <Module>[
    AuthModule(),
    AnalyticsModule(),
    SplashModule(),
    LoginSignUModule(),
    ProfileModule(),
  ].forEach((module) => module.setup());
}

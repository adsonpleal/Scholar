import 'package:app_tcc/modules/login/login_signup_page.dart';
import 'package:app_tcc/modules/main/main_page.dart';
import 'package:app_tcc/modules/splash/splash_page.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:app_tcc/utils/analytics.dart';
import 'package:app_tcc/utils/routes.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final RouteObserver observer;

  App(Analytics analytics) : observer = analytics.observer;

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: Strings.appName,
      navigatorObservers: [
        observer,
      ],
      routes: {
        Routes.root: (c) => SplashPage(),
        Routes.login: (c) => LoginSignUpPage(),
        Routes.main: (c) => MainPage(observer),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ));
}

void main() => runApp(App(Analytics()));

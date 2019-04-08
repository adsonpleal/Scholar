import 'package:app_tcc/modules/login/login_signup_page.dart';
import 'package:app_tcc/modules/main/main_page.dart';
import 'package:app_tcc/modules/splash/splash_page.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:app_tcc/utils/routes.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: Strings.appName,
      routes: {
        Routes.root: (c) => SplashPage(),
        Routes.login: (c) => LoginSignUpPage(),
        Routes.main: (c) => MainPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ));
}

void main() => runApp(App());

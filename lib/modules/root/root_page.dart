import 'package:app_tcc/modules/login/auth_repository.dart';
import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:app_tcc/modules/login/login_signup_page.dart';
import 'package:app_tcc/modules/main/main_page.dart';
import 'package:app_tcc/modules/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootPage extends StatefulWidget {
  @override
  createState() => RootPageState();
}

class RootPageState extends State<RootPage> {
  final _loginSignUpBloc = LoginSignUpBloc(FirebaseAuthRepository());

  @override
  void initState() {
    super.initState();
    _loginSignUpBloc.checkAuthentication();
  }

  @override
  build(BuildContext context) => BlocProvider(
        bloc: _loginSignUpBloc,
        child: BlocBuilder(
            bloc: _loginSignUpBloc,
            builder: (context, state) {
              if (state is SplashState) {
                return SplashPage();
              }
              if (state is UnauthenticatedState) {
                return LoginSignUpPage();
              }
              return MainPage();
            }),
      );

  @override
  void dispose() {
    _loginSignUpBloc.dispose();
    super.dispose();
  }
}

//
//class LoginSignUpSate extends State<RootPage> {
//  final _counterBloc = CounterBloc();
//
//  @override
//  build(BuildContext context) => Scaffold(
//    appBar: AppBar(title: Text('Counter')),
//    body: BlocBuilder(
//      bloc: _counterBloc,
//      builder: (BuildContext context, int count) => Center(
//        child: Text(
//          '$count',
//          style: TextStyle(fontSize: 24.0),
//        ),
//      ),
//    ),
//    floatingActionButton: Column(
//      crossAxisAlignment: CrossAxisAlignment.end,
//      mainAxisAlignment: MainAxisAlignment.end,
//      children: <Widget>[
//        Padding(
//          padding: EdgeInsets.symmetric(vertical: 5.0),
//          child: FloatingActionButton(
//            child: Icon(Icons.add),
//            onPressed: _counterBloc.increment,
//          ),
//        ),
//        Padding(
//          padding: EdgeInsets.symmetric(vertical: 5.0),
//          child: FloatingActionButton(
//            child: Icon(Icons.remove),
//            onPressed: _counterBloc.decrement,
//          ),
//        ),
//      ],
//    ),
//  );
//
//  @override
//  void dispose() {
//    _counterBloc.dispose();
//    super.dispose();
//  }
//}

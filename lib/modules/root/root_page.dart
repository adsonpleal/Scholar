import 'package:app_tcc/modules/login/login_signup_page.dart';
import 'package:app_tcc/modules/main/main_page.dart';
import 'package:app_tcc/modules/root/root_bloc.dart';
import 'package:app_tcc/modules/root/root_module.dart';
import 'package:app_tcc/modules/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootPage extends StatefulWidget {
  final RootModule module;

  const RootPage({Key key, this.module = const RootModule()}) : super(key: key);

  @override
  createState() => RootPageState(module);
}

class RootPageState extends State<RootPage> {
  final RootBloc _rootBlock;

  RootPageState(RootModule module) : this._rootBlock = module.bloc;

  @override
  void initState() {
    super.initState();
    _rootBlock.checkAuthentication();
  }

  @override
  build(BuildContext context) => BlocProvider(
        bloc: _rootBlock,
        child: BlocBuilder(
            bloc: _rootBlock,
            builder: (context, state) {
              switch (state) {
                case RootState.splash:
                  return SplashPage();
                case RootState.unauthenticated:
                  return LoginSignUpPage();
                case RootState.authenticated:
                  return MainPage();
              }
            }),
      );

  @override
  void dispose() {
    _rootBlock.dispose();
    super.dispose();
  }
}

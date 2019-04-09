import 'package:app_tcc/modules/splash/splash_bloc.dart';
import 'package:app_tcc/modules/splash/splash_module.dart';
import 'package:app_tcc/utils/widgets/routing_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  final SplashModule module;

  const SplashPage({Key key, this.module = const SplashModule()})
      : super(key: key);

  @override
  createState() => _SplashPageState(module);
}

class _SplashPageState extends State<SplashPage> {
  final SplashBloc _splashBloc;

  _SplashPageState(SplashModule module) : this._splashBloc = module.bloc;

  @override
  void initState() {
    super.initState();
    _splashBloc.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _splashBloc,
      builder: (context, state) => RoutingWrapper(
          route: state.route?.value, child: Center(child: Text("Splash"))));
}

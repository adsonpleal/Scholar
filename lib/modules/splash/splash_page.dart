import 'package:app_tcc/modules/login/components/logo.dart';
import 'package:app_tcc/modules/splash/splash_bloc.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/widgets/routing_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  @override
  createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashBloc _splashBloc = inject();

  @override
  void initState() {
    super.initState();
    _splashBloc.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder(
        bloc: _splashBloc,
        builder: (context, state) => RoutingWrapper(
              route: state.route?.value,
              child: Scaffold(),
            ),
      );

  @override
  void dispose() {
    _splashBloc?.dispose();
    super.dispose();
  }
}

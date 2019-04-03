import 'package:app_tcc/modules/root/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _rootBloc = BlocProvider.of<RootBloc>(context);
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Splash Screen'),
              FlatButton(
                child: Text('Log out'),
                onPressed: _rootBloc.logout,
              )
            ],
          )),
    );
  }
}

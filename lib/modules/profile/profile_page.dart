import 'package:app_tcc/modules/root/root_bloc.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _rootBloc = BlocProvider.of<RootBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('PROFILE'),
              FlatButton(
                child: Text('Log out'),
                onPressed: _rootBloc.logout,
              )
            ],
      ),
    ),
    );
    
  }
}
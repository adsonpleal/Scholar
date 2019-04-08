import 'package:app_tcc/modules/root/root_bloc.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';


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
            ),
            FlatButton(
              child: Text('Conectar UFSC'),
              onPressed: _conectUFSC,
            ),
          ],
        ),
      ),
    );
  }

  _conectUFSC() async {
    const url = 'https://sistemas.ufsc.br/oauth2.0/authorize?client_id=minhaufsc&redirect_uri=minhaufsc://minhaufsc.setic_oauth.ufsc.br&response_type=code&state=E3ZYKC1T6H2yP4z';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

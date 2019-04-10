import 'package:app_tcc/modules/profile/profile_bloc.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/widgets/routing_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  static instantiate() => ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileBloc _profileBloc = inject();

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _profileBloc,
      builder: (context, state) => RoutingWrapper(
          route: state.route?.value,
          child: Scaffold(
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
                    onPressed: _profileBloc.logOut,
                  ),
                  FlatButton(
                    child: Text('Conectar UFSC'),
                    onPressed: _conectUFSC,
                  ),
                ],
              ),
            ),
          )));

  _conectUFSC() async {
    const url =
        'https://sistemas.ufsc.br/oauth2.0/authorize?client_id=minhaufsc&redirect_uri=minhaufsc://minhaufsc.setic_oauth.ufsc.br&response_type=code&state=E3ZYKC1T6H2yP4z';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _profileBloc?.dispose();
    super.dispose();
  }
}

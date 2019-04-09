import 'package:app_tcc/modules/profile/profile_bloc.dart';
import 'package:app_tcc/modules/profile/profile_module.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:app_tcc/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final ProfileModule module;

  static instantiate() => ProfilePage();

  const ProfilePage({Key key, this.module = const ProfileModule()})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState(module);
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileBloc _profileBloc;

  _ProfilePageState(ProfileModule module) : _profileBloc = module.bloc;

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _profileBloc,
      builder: (context, state) {
        Routes.replace(context, state.route?.value);
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
                  onPressed: _profileBloc.logOut,
                ),
                FlatButton(
                  child: Text('Conectar UFSC'),
                  onPressed: _conectUFSC,
                ),
              ],
            ),
          ),
        );
      });

  _conectUFSC() async {
    const url =
        'https://sistemas.ufsc.br/oauth2.0/authorize?client_id=minhaufsc&redirect_uri=minhaufsc://minhaufsc.setic_oauth.ufsc.br&response_type=code&state=E3ZYKC1T6H2yP4z';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

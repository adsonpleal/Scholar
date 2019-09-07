import 'package:app_tcc/models/restaurant.dart';
import 'package:app_tcc/modules/profile/profile_bloc.dart';
import 'package:app_tcc/modules/profile/profile_state.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/widgets/loading_wrapper.dart';
import 'package:app_tcc/utils/widgets/routing_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  static Widget instantiate() => ProfilePage();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileBloc _profileBloc = inject();

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _profileBloc,
      builder: (context, ProfileState state) {
        final isConnected = state.settings?.connected == true;
        return RoutingWrapper(
            route: state.route?.value,
            child: Scaffold(
                appBar: AppBar(
                  title: Text(Strings.profile),
                ),
                body: LoadingWrapper(
                  isLoading: state.loading,
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text(state.user?.email ?? ""),
                      ),
                      ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text(Strings.exit),
                        onTap: _profileBloc.dispatchLogoutEvent,
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          Strings.config,
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.school),
                        title: Text(isConnected
                            ? Strings.refreshUfsc
                            : Strings.connectUfsc),
                        onTap: showAlertIfConnected(isConnected),
                      ),
                      Visibility(
                        visible: state.hasRestaurant,
                        child: ListTile(
                          onTap: () {},
                          leading: Icon(Icons.restaurant),
                          title: DropdownButton<Restaurant>(
                            underline: Container(),
                            isExpanded: true,
                            items: state.restaurants
                                ?.map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value.name),
                                    ))
                                ?.toList(),
                            value: state.selectedRestaurant,
                            onChanged: _profileBloc.onRestaurantChanged,
                          ),
                        ),
                      ),
                      SwitchListTile(
                        title: Text(Strings.notifications),
                        value: state.settings?.allowNotifications ?? false,
                        onChanged: (_) =>
                            _profileBloc.dispatchToggleNotificationsEvent(),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          Strings.contact,
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.help_outline),
                        title: Text(Strings.foundABug),
                        onTap: _profileBloc.launchContactEmail,
                      ),
                    ],
                  ),
                )));
      });

  Function showAlertIfConnected(bool isConnected) {
    if (!isConnected) {
      return _profileBloc.launchAuthorization;
    }
    return () => showDialog<void>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(Strings.refreshData),
            content: Text(Strings.refreshDataContent),
            actions: <Widget>[
              FlatButton(
                child: Text(Strings.cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(Strings.confirm),
                onPressed: () {
                  Navigator.of(context).pop();
                  _profileBloc.launchAuthorization();
                },
              ),
            ],
          ),
        );
  }

  @override
  void dispose() {
    _profileBloc?.dispose();
    super.dispose();
  }
}

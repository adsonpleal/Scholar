import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/subject_query.dart';
import 'package:app_tcc/utils/widgets/routing_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'connect_ufsc_bloc.dart';

class ConnectUfscPage extends StatefulWidget {
  @override
  _ConnectUfscPageState createState() => _ConnectUfscPageState();
}

class _ConnectUfscPageState extends State<ConnectUfscPage> {
  final ConnectUfscBloc _bloc = inject();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _bloc,
        builder: (context, ConnectUfscState state) => RoutingWrapper(
            action: state == ConnectUfscState.connected ? RoutingAction.pop : null,
            child: WebviewScaffold(url: subjectUrl)));
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }
}

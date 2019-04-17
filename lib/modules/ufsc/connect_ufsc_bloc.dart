import 'dart:async';
import 'dart:convert';

import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/subject_query.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

enum ConnectUfscState { initial, connected }

class _ConnectUfscEvent {}

class ConnectUfscBloc extends Bloc<_ConnectUfscEvent, ConnectUfscState> {
  final UserDataRepository _userData = inject();

  ConnectUfscBloc() {
    dispatch(_ConnectUfscEvent());
  }

  @override
  ConnectUfscState get initialState => ConnectUfscState.initial;

  @override
  Stream<ConnectUfscState> mapEventToState(_ConnectUfscEvent event) async* {
    final webViewPlugin = FlutterWebviewPlugin();
    await webViewPlugin.onStateChanged.firstWhere((state) =>
        state.type == WebViewState.finishLoad && state.url == subjectUrl);
    final result = await webViewPlugin.evalJavascript(subjectQuery);
    webViewPlugin.cleanCookies();
    final subjects = Subject.fromJsonList(json.decode(result));
    _userData.saveSubjects(subjects);
    yield ConnectUfscState.connected;
  }
}

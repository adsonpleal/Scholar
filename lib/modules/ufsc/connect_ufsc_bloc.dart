import 'dart:async';
import 'dart:convert';

import 'package:app_tcc/models/subject.dart';
import 'package:app_tcc/modules/notifications/notifications_service.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/subject_query.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:bloc_builder/annotations.dart';

part 'connect_ufsc_bloc.g.dart';

enum ConnectUfscState { initial, connected }

@BuildBloc(ConnectUfscState)
class ConnectUfscBloc extends _$Bloc {
  final UserDataRepository _userData = inject();
  final NotificationsService _notifications = inject();

  ConnectUfscBloc() {
    dispatchConnectEvent();
  }

  @override
  ConnectUfscState get initialState => ConnectUfscState.initial;

  Stream<ConnectUfscState> _mapConnectToState() async* {
    final webViewPlugin = FlutterWebviewPlugin();
    await webViewPlugin.onStateChanged.firstWhere((state) =>
        state.type == WebViewState.finishLoad && state.url == subjectUrl);
    final result = await webViewPlugin.evalJavascript(subjectQuery);
    webViewPlugin.cleanCookies();
    final subjects = Subject.fromJsonList(json.decode(result));
    _userData.replaceSubjects(subjects);
    final settings = await _userData.settings;
    if (settings.allowNotifications) {
      _notifications.addNotifications(subjects);
    }
    await _userData
        .saveSettings(settings.rebuild((b) => b..restaurantId = 'trindade'));
    yield ConnectUfscState.connected;
  }

  @override
  void dispose() {
    _notifications.dispose();
    super.dispose();
  }
}

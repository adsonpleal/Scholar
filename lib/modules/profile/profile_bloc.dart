import 'dart:async';

import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/repositories/auth_repository.dart';
import 'package:app_tcc/utils/routes.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uni_links/uni_links.dart';

class ProfileState extends Equatable {
  final SingleEvent<String> route;

  ProfileState({this.route}) : super([route]);
  factory ProfileState.initial() => ProfileState();
  factory ProfileState.login() => ProfileState(route: SingleEvent(Routes.login));
}

class _ProfileEvent {}

class _ProfileLogOutEvent extends _ProfileEvent {}

class _UFSCConnectedEvent extends _ProfileEvent {
  final String code;
  final String state;

  _UFSCConnectedEvent(this.code, this.state);
}

class ProfileBloc extends Bloc<_ProfileEvent, ProfileState> {
  final AuthRepository _auth;
  StreamSubscription<Uri> _linksSub;

  ProfileBloc(this._auth) {
    _initUniLinks();
  }

  @override
  ProfileState get initialState => ProfileState.initial();

  @override
  Stream<ProfileState> mapEventToState(_ProfileEvent event) async* {
    if (event is _ProfileLogOutEvent) yield* _logoutToState();
    if (event is _UFSCConnectedEvent) yield* _connectedToState(event);
  }

  Stream<ProfileState> _connectedToState(_UFSCConnectedEvent event) async* {}

  Stream<ProfileState> _logoutToState() async* {
    await _auth.signOut();
    yield ProfileState.login();
  }

  @override
  dispose() {
    _linksSub.cancel();
    super.dispose();
  }

  logOut() => dispatch(_ProfileLogOutEvent());

  _initUniLinks() async {
    _linksSub = getUriLinksStream().listen((Uri uri) {
      final params = uri.queryParameters;
      final code = params['code'];
      final state = params['state'];
      dispatch(_UFSCConnectedEvent(code, state));
    }, onError: (err) {
      // TODO: handle link errors
      print(err);
    });
  }
}

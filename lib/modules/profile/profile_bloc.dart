import 'dart:async';

import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/models/user.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/profile/link_repository.dart';
import 'package:app_tcc/modules/user_data/user_data_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/routes.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uni_links/uni_links.dart';

class ProfileState extends Equatable {
  final SingleEvent<String> route;
  final User user;
  final bool loading;

  ProfileState({this.route, this.user, this.loading = false})
      : super([route, user, loading]);
  factory ProfileState.initial() => ProfileState();
  factory ProfileState.login() =>
      ProfileState(route: SingleEvent(Routes.login));

  ProfileState changeValue({route, user, loading}) => ProfileState(
        route: route ?? this.route,
        user: user ?? this.user,
        loading: loading ?? this.loading,
      );
}

class _ProfileEvent {}

class _ProfileLogOutEvent extends _ProfileEvent {}

class _TrackUserEvent extends _ProfileEvent {}

class _UFSCConnectedEvent extends _ProfileEvent {
  final String code;
  final String state;

  _UFSCConnectedEvent(this.code, this.state);
}

class ProfileBloc extends Bloc<_ProfileEvent, ProfileState> {
  final AuthRepository _auth = inject();
  final UserDataRepository _userData = inject();
  final LinkRepository _link = inject();
  StreamSubscription<Uri> _linksSub;

  ProfileBloc() {
    _initUniLinks();
    _trackUserData();
  }

  @override
  ProfileState get initialState => ProfileState.initial();

  @override
  Stream<ProfileState> mapEventToState(_ProfileEvent event) async* {
    if (event is _ProfileLogOutEvent) yield* _logoutToState();
    if (event is _UFSCConnectedEvent) yield* _connectedToState(event);
    if (event is _TrackUserEvent) yield* _trackUserToState();
  }

  Stream<ProfileState> _connectedToState(_UFSCConnectedEvent event) async* {}

  Stream<ProfileState> _trackUserToState() async* {
    yield currentState.changeValue(loading: true);
    final userStream = await _userData.userStream;
    yield* userStream
        .map((user) => currentState.changeValue(user: user, loading: false));
  }

  Stream<ProfileState> _logoutToState() async* {
    await _auth.signOut();
    yield ProfileState.login();
  }

  @override
  dispose() {
    _linksSub?.cancel();
    super.dispose();
  }

  logOut() => dispatch(_ProfileLogOutEvent());

  _initUniLinks() async {
    _linksSub = await _link.uriLinksStream.map((Uri uri) {
      final params = uri.queryParameters;
      final code = params['code'];
      final state = params['state'];
      return _UFSCConnectedEvent(code, state);
    }).forEach(dispatch);
  }

  _trackUserData() => dispatch(_TrackUserEvent());
}

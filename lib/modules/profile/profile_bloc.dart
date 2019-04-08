import 'dart:async';

import 'package:app_tcc/modules/root/root_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uni_links/uni_links.dart';

class ProfileState extends Equatable {
  ProfileState([args]) : super(args);
}

class _ProfileEvent {}

class _ProfileLogOutEvent extends _ProfileEvent {}

class _UFSCConnectedEvent extends _ProfileEvent {
  final String code;
  final String state;

  _UFSCConnectedEvent(this.code, this.state);
}

class ProfileBloc extends Bloc<_ProfileEvent, ProfileState> {
  final RootBloc _rootBloc;
  StreamSubscription<Uri> _linksSub;

  ProfileBloc(this._rootBloc) {
    _initUniLinks();
  }

  @override
  ProfileState get initialState => ProfileState();

  @override
  Stream<ProfileState> mapEventToState(_ProfileEvent event) async* {
    if (event is _ProfileLogOutEvent) _rootBloc.logout();
    if (event is _UFSCConnectedEvent) yield* _connectedToState(event);
  }

  Stream<ProfileState> _connectedToState(_UFSCConnectedEvent event) async* {
    
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

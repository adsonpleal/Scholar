import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/routes.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  final SingleEvent<String> route;

  SplashState({this.route}) : super([route]);
  factory SplashState.initial() => SplashState();
  factory SplashState.login() => SplashState(route: SingleEvent(Routes.login));
  factory SplashState.main() => SplashState(route: SingleEvent(Routes.main));
}

enum _SplashEvent { checkAuthentication }

class SplashBloc extends Bloc<_SplashEvent, SplashState> {
  final AuthRepository _auth = inject();

  @override
  SplashState get initialState => SplashState.initial();

  @override
  Stream<SplashState> mapEventToState(_SplashEvent event) async* {
    final user = await _auth.getCurrentUser();
    if (user != null) {
      yield SplashState.main();
    } else {
      yield SplashState.login();
    }
  }

  checkAuthentication() => dispatch(_SplashEvent.checkAuthentication);
}

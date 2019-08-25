import 'package:app_tcc/modules/analytics/error_tracker.dart';
import 'package:app_tcc/modules/auth/auth_repository.dart';
import 'package:app_tcc/modules/splash/splash_state.dart';
import 'package:app_tcc/utils/inject.dart';
import 'package:bloc/bloc.dart';

enum _SplashEvent { checkAuthentication }

class SplashBloc extends Bloc<_SplashEvent, SplashState> {
  final AuthRepository _auth = inject();
  final ErrorTracker _errorTracker = inject();

  @override
  SplashState get initialState => SplashState.initial();

  @override
  Stream<SplashState> mapEventToState(_SplashEvent event) async* {
    final user = await _auth.currentUser;
    if (user != null) {
      _errorTracker.initUser(user);
      yield SplashState.main();
    } else {
      yield SplashState.login();
    }
  }

  checkAuthentication() => dispatch(_SplashEvent.checkAuthentication);
}

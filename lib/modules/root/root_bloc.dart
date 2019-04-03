import 'package:app_tcc/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';

enum RootState { splash, unauthenticated, authenticated }
enum _RootEvent { checkAuthentication, logout }

class RootBloc extends Bloc<_RootEvent, RootState> {
  RootBloc(this._auth);
  final AuthRepository _auth;

  @override
  RootState get initialState => RootState.splash;

  @override
  Stream<RootState> mapEventToState(_RootEvent event) async* {
    switch (event) {
      case _RootEvent.logout:
        yield* _mapLogOutToState();
        break;
      case _RootEvent.checkAuthentication:
        yield* _mapCheckAuthToState();
        break;
    }
  }
  
  Stream<RootState> _mapLogOutToState() async* {
    await _auth.signOut();
    yield RootState.unauthenticated;
  }

  Stream<RootState> _mapCheckAuthToState() async* {
    final user = await _auth.getCurrentUser();
    if (user != null) {
      yield RootState.authenticated;
    } else {
      yield RootState.unauthenticated;
    }
  }

  checkAuthentication() => dispatch(_RootEvent.checkAuthentication);
  logout() => dispatch(_RootEvent.logout);
}

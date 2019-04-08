import 'package:app_tcc/modules/splash/splash_bloc.dart';
import 'package:app_tcc/repositories/auth_repository.dart';

class SplashModule {
  const SplashModule();
  SplashBloc get bloc => SplashBloc(AuthRepository());
}
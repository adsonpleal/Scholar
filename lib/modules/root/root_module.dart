import 'package:app_tcc/modules/root/root_bloc.dart';
import 'package:app_tcc/repositories/auth_repository.dart';

class RootModule {
  const RootModule();
  RootBloc get bloc => RootBloc(AuthRepository());
}
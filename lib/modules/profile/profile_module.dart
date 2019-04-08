
import 'package:app_tcc/modules/profile/profile_bloc.dart';
import 'package:app_tcc/repositories/auth_repository.dart';

class ProfileModule {
  const ProfileModule();
  ProfileBloc get bloc => ProfileBloc(AuthRepository());
}
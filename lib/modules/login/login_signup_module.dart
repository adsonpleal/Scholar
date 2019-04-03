import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:app_tcc/modules/root/root_bloc.dart';
import 'package:app_tcc/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginSignUpModule {
  const LoginSignUpModule();
  LoginSignUpBloc getBloc(BuildContext context) => LoginSignUpBloc(AuthRepository(), BlocProvider.of<RootBloc>(context));
}

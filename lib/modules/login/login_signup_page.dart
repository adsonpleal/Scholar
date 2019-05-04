import 'package:app_tcc/modules/login/components/forgot_password_button.dart';
import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:app_tcc/modules/login/login_signup_state.dart';
import 'package:app_tcc/resources/strings.dart' as Strings;
import 'package:app_tcc/utils/inject.dart';
import 'package:app_tcc/utils/widgets/info_alert.dart';
import 'package:app_tcc/utils/widgets/loading_wrapper.dart';
import 'package:app_tcc/utils/widgets/routing_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/login_components.dart';

class LoginSignUpPage extends StatefulWidget {
  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final LoginSignUpBloc _loginSignUpBloc = inject();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  void _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _loginSignUpBloc.dispatchSubmitEvent();
    }
  }

  void _onEmailSubmitted(FormMode formMode) {
    if (formMode == FormMode.resetPassword) {
      _validateAndSave();
    } else {
      _emailFocus.unfocus();
      FocusScope.of(context).requestFocus(_passwordFocus);
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _loginSignUpBloc,
      builder: (context, LoginSignUpState state) => RoutingWrapper(
          route: state.route?.value,
          child: InfoAlert(
              title: Strings.emailSent,
              content: Strings.emailSentResetPassword,
              shouldShow: state.showResetPasswordDialog?.value,
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(Strings.appName),
                  ),
                  body: LoadingWrapper(
                    isLoading: state.loading,
                    child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Form(
                          onChanged: () => _formKey.currentState.validate(),
                          key: _formKey,
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              const Logo(),
                              EmailInput(
                                focusNode: _emailFocus,
                                formMode: state.formMode,
                                validator: _loginSignUpBloc.validateEmail,
                                onSaved: _loginSignUpBloc.onEmailSaved,
                                onFieldSubmitted: () =>
                                    _onEmailSubmitted(state.formMode),
                              ),
                              PasswordInput(
                                focusNode: _passwordFocus,
                                formMode: state.formMode,
                                validator: _loginSignUpBloc.validatePassword,
                                onSaved: _loginSignUpBloc.onPasswordSaved,
                                onFieldSubmitted: _validateAndSave,
                              ),
                              PrimaryButton(
                                formMode: state.formMode,
                                onPressed: _validateAndSave,
                              ),
                              SecondaryButton(
                                formMode: state.formMode,
                                onPressed: _loginSignUpBloc.dispatchToggleEvent,
                              ),
                              ForgotPasswordButton(
                                formMode: state.formMode,
                                onPressed: _loginSignUpBloc.dispatchToggleResetEvent,
                              ),
                              ErrorMessage(
                                errorMessage: state.errorMessage,
                              )
                            ],
                          ),
                        )),
                  )))));

  @override
  void dispose() {
    _loginSignUpBloc?.dispose();
    super.dispose();
  }
}

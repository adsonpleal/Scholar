import 'package:app_tcc/models/single_event.dart';
import 'package:app_tcc/modules/loading/loading_wrapper.dart';
import 'package:app_tcc/modules/login/components/forgot_password_button.dart';
import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:app_tcc/modules/login/login_signup_module.dart';
import 'package:app_tcc/resources/strings.dart';
import 'package:app_tcc/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/login_components.dart';

class LoginSignUpPage extends StatefulWidget {
  final LoginSignUpModule module;

  const LoginSignUpPage({Key key, this.module = const LoginSignUpModule()})
      : super(key: key);

  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState(module);
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final LoginSignUpBloc _loginSignUpBloc;
  final _formKey = GlobalKey<FormState>();

  _LoginSignUpPageState(LoginSignUpModule module)
      : _loginSignUpBloc = module.bloc;

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _loginSignUpBloc,
      builder: (context, state) {
        _showResetPasswordDialog(context, state.showResetPasswordDialog);
        Routes.replace(context, state.route?.value);
        return Scaffold(
            appBar: AppBar(
              title: Text(Strings.appName),
            ),
            body: LoadingWrapper(
              isLoading: state.loading,
              child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Logo(),
                        EmailInput(
                          validator: _loginSignUpBloc.validateEmail,
                          onSaved: _loginSignUpBloc.onEmailSaved,
                        ),
                        PasswordInput(
                            formMode: state.formMode,
                            validator: _loginSignUpBloc.validatePassword,
                            onSaved: _loginSignUpBloc.onPasswordSaved),
                        PrimaryButton(
                          formMode: state.formMode,
                          onPressed: () =>
                              _loginSignUpBloc.submit(_validateAndSave()),
                        ),
                        SecondaryButton(
                          formMode: state.formMode,
                          onPressed: _loginSignUpBloc.toggleFormMode,
                        ),
                        ForgotPasswordButton(
                          formMode: state.formMode,
                          onPressed: _loginSignUpBloc.toggleResetPassword,
                        ),
                        ErrorMessage(
                          errorMessage: state.errorMessage,
                        )
                      ],
                    ),
                  )),
            ));
      });

  void _showResetPasswordDialog(
      BuildContext context, SingleEvent<bool> shouldShow) {
    if (shouldShow?.value == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showDialog<void>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text(Strings.emailSent),
                  content: const Text(Strings.emailSentResetPassword),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(Strings.ok),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
          ));
    }
  }

  @override
  void dispose() {
    _loginSignUpBloc?.dispose();
    super.dispose();
  }
}

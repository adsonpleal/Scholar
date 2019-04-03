import 'package:app_tcc/modules/loading/loading_wrapper.dart';
import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:app_tcc/modules/login/login_signup_module.dart';
import 'package:app_tcc/resources/strings.dart';
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
  final LoginSignUpModule _module;
  LoginSignUpBloc _loginSignUpBloc;
  final _formKey = GlobalKey<FormState>();

  _LoginSignUpPageState(this._module);

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _initBloc(BuildContext context) {
    if (_loginSignUpBloc == null) {
      _loginSignUpBloc = _module.getBloc(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _initBloc(context);
    return BlocBuilder(
        bloc: _loginSignUpBloc,
        builder: (context, state) {
          final isLogin = state.formMode == FormMode.login;
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
                              validator: _loginSignUpBloc.validatePassword,
                              onSaved: _loginSignUpBloc.onPasswordSaved),
                          PrimaryButton(
                            isLogin: state.formMode == FormMode.login,
                            onPressed: () =>
                                _loginSignUpBloc.submit(_validateAndSave()),
                          ),
                          SecondaryButton(
                            isLogin: isLogin,
                            onPressed: _loginSignUpBloc.toggleFormMode,
                          ),
                          ErrorMessage(
                            errorMessage: state.errorMessage,
                          )
                        ],
                      ),
                    )),
              ));
        });
  }

  @override
  void dispose() {
    _loginSignUpBloc?.dispose();
    super.dispose();
  }
}

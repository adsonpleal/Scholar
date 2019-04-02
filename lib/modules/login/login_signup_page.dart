import 'package:app_tcc/modules/loading/loading_wrapper.dart';
import 'package:app_tcc/modules/login/login_signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/login_components.dart';

class LoginSignUpPage extends StatefulWidget {
  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {

  final _formKey = GlobalKey<FormState>();

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final _loginSignUpBloc = BlocProvider.of<LoginSignUpBloc>(context);
    return BlocBuilder(
        bloc: _loginSignUpBloc,
        builder: (context, state) {
          final uState = state as UnauthenticatedState;
          final isLogin = uState.formMode == FormMode.login;
          return Scaffold(
              appBar: AppBar(
                title: Text('Flutter login demo'),
              ),
              body: LoadingWrapper(
                isLoading: uState.loading,
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
                            isLogin: uState.formMode == FormMode.login,
                            onPressed: () => _loginSignUpBloc.submit(_validateAndSave()),
                          ),
                          SecondaryButton(
                            isLogin: isLogin,
                            onPressed: _loginSignUpBloc.toggleFormMode,
                          ),
                          ErrorMessage(
                            errorMessage: uState.errorMessage,
                          )
                        ],
                      ),
                    )),
              ));
        });
  }
}

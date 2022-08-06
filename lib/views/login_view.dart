import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_dart/extensions/buildcontext/loc.dart';
import 'package:learning_dart/services/auth/auth_exceptions.dart';
import 'package:learning_dart/services/auth/bloc/auth_bloc.dart';
import 'package:learning_dart/services/auth/bloc/auth_event.dart';
import 'package:learning_dart/services/auth/bloc/auth_state.dart';
import 'package:learning_dart/utility/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {

  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _email;
  late final TextEditingController _pass;

  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(context, context.loc.login_error_cannot_find_user,);
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, context.loc.login_error_wrong_credentials,);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, context.loc.login_error_auth_error,);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title:  Text(context.loc.note),),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(context.loc.login_view_prompt),
              TextField(
                controller: _email,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: (context.loc.email_text_field_placeholder),

                ),
              ),
              TextField(
                controller: _pass,
                autocorrect: false,
                enableSuggestions: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: (context.loc.password_text_field_placeholder),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _pass.text;
                  context.read<AuthBloc>().add(
                    AuthEventLogin(
                      email,
                      password,
                    ),
                  );
                },
                child: Text(context.loc.login),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventForgotPassword());
                },
                child: Text(context.loc.login_view_forgot_password),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: Text(context.loc.login_view_not_registered_yet),)
            ],
          ),
        ),
      ),
    );
  }
}


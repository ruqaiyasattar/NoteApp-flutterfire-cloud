import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_dart/extensions/buildcontext/loc.dart';
import 'package:learning_dart/services/auth/auth_exceptions.dart';
import 'package:learning_dart/services/auth/bloc/auth_bloc.dart';
import 'package:learning_dart/services/auth/bloc/auth_event.dart';
import 'package:learning_dart/services/auth/bloc/auth_state.dart';
import 'package:learning_dart/utility/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        if (state is AuthStateRegistering) {
          if (state.exception is WeekPasswordAuthException) {
            await showErrorDialog(context, context.loc.register_error_weak_password,);
          }  else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, context.loc.register_error_email_already_in_use,);
          }  else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, context.loc.register_error_invalid_email,);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context,  context.loc.register_error_generic,);
          }
        }
     },
      child: Scaffold(
        appBar: AppBar(title:  Text(context.loc.register,)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.loc.register_view_prompt),
                TextField(
                  controller: _email,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: (context.loc.email_text_field_placeholder),
                  ),
                ),
                TextField(
                  controller: _pass,
                  autocorrect: false,
                  autofocus: true,
                  enableSuggestions: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: (context.loc.password_text_field_placeholder),
                  ),
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _pass.text;
                        context.read<AuthBloc>().
                        add(AuthEventRegister(
                          email,
                          password,
                        ));
                      },

                      child: Text(context.loc.register),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          context.read<AuthBloc>()
                              .add(const AuthEventLogOut(),
                          );
                        },
                        child: Text(context.loc.register_view_already_registered,)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

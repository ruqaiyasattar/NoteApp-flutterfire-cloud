
import 'package:flutter/material.dart';
import 'package:learning_dart/services/auth/auth_exceptions.dart';
import 'package:learning_dart/services/auth/auth_service.dart';
import 'package:learning_dart/utility/dialogs/error_dialog.dart';
import '../constant/routes.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Login'),      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: ("Email"),

            ),
          ),
          TextField(
            controller: _pass,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: ("Password"),
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _pass.text;

              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if(user?.isEmailVerified ?? false){
                  //email is verified
                  if(!mounted) return;
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else {
                  //email not verified
                  if(!mounted) return;
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(verifyRoute, (route) => false);
                }

              } on UserNotFoundAuthException{
                await showErrorDialog(context,"User Not Found");
              } on WrongPasswordAuthException{
                await showErrorDialog(context,"Wrong Password");
              } on GenericAuthException{
                await showErrorDialog(context,'Authentication Error');
              }
            },

            child: const Text('Login'),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                      (route) => false);
            },
            child:const Text('Not register yet? Register here!'),)
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:learning_dart/constant/routes.dart';
import 'package:learning_dart/services/auth/auth_exceptions.dart';
import 'package:learning_dart/services/auth/auth_service.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
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
              try{
                await AuthService.firebase().createUser(email: email, password: password);
                await AuthService.firebase().sendEmailVerification();
                if(!mounted) return;
                Navigator.of(context).pushNamed(verifyRoute);
              }  on WeekPasswordAuthException{
                await showErrorDialog(context,"Weak Password");
              } on EmailAlreadyInUseAuthException{
                await showErrorDialog(context,"Email Already In Use");
              }on InvalidEmailAuthException{
                await showErrorDialog(context,"Invalid Email");
              } on GenericAuthException{
                await showErrorDialog(context,'Authentication Error');
              }
            },

            child: const Text('Register'),
          ),
          TextButton(
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context,
                    loginRoute,
                        (route) => false);
              },
              child: const Text('Login'))
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:learning_dart/services/auth/auth_service.dart';

import '../constant/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify'),),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text("We've sent you the email Verification. Please open it to verify your account"),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text("If you haven't received a verification email yet, press the button below"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child:const Text("Email Verification"),
          ),
          TextButton(
            onPressed: (){
              AuthService.firebase().logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                      (route) => false);
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}

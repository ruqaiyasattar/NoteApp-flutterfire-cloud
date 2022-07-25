import 'package:flutter/material.dart';
import 'package:learning_dart/services/auth/auth_service.dart';
import 'package:learning_dart/views/login_view.dart';
import 'package:learning_dart/views/notes/create_update_note_view.dart';
import 'package:learning_dart/views/notes/notes_view.dart';
import 'package:learning_dart/views/register_view.dart';
import 'package:learning_dart/views/verify_email_view.dart';
import 'constant/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomePage(),
          initialRoute: '/',
          routes: {
            registerRoute: (context) => const RegisterView(),
            loginRoute:   (context) => const LoginView(),
            notesRoute:   (context) => const NotesView(),
            verifyRoute:  (context) => const VerifyEmailView(),
            createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
          }
      )
  );
}

class HomePage extends StatelessWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //future
      future: AuthService.firebase().initialize(),
      //builder

      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.done:
            final user= AuthService.firebase().currentUser;
            if(user != null){
              if(user.isEmailVerified){
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }//switch end
      },//builder end
    );
  }
}




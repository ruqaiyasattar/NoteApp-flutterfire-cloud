import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_dart/helpers/loading/loading_screen.dart';
import 'package:learning_dart/services/auth/bloc/auth_bloc.dart';
import 'package:learning_dart/services/auth/bloc/auth_event.dart';
import 'package:learning_dart/services/auth/bloc/auth_state.dart';
import 'package:learning_dart/services/auth/firebase_auth_provider.dart';
import 'package:learning_dart/views/forgot_password_view.dart';
import 'package:learning_dart/views/login_view.dart';
import 'package:learning_dart/views/notes/create_update_note_view.dart';
import 'package:learning_dart/views/notes/notes_view.dart';
import 'package:learning_dart/views/register_view.dart';
import 'package:learning_dart/views/verify_email_view.dart';
import 'constant/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(FireBaseAuthProvider()),
            child: const HomePage(),
          ),
          initialRoute: '/',
          routes: {
            createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
          },

      )
  );
}
/*Future initilization(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 3));
}*/


class HomePage extends StatelessWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state){
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        }  else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state){
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        }  else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        }  else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        }
        else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

//counter bloc for understanding
/*
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title:const Text('Testing bloc'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
         builder:(context, state) {
           final invalidValue = (state is CounterStateInValidNumber) ? state.invalidValue : ' ';
            return  Column(
              children: [
                Text("Current value ==> ${state.value}"),
                Visibility(
                  visible: state is CounterStateInValidNumber,
                  child:  Text('Invalid Input : $invalidValue'),
                ),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter a number here',
                  ),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: (){
                        context.read<CounterBloc>()
                            .add(DecrementEvent(_controller.text));
                      },
                      child:const Text('-'),
                    ),
                    TextButton(
                      onPressed: (){
                        context.read<CounterBloc>()
                            .add(IncrementEvent(_controller.text));
                      },
                      child:const Text('+'),
                    ),
                  ],
                ),
              ],
            );
         },
        ),
      ),

    );
  }
}
//state
@immutable
abstract class CounterState{
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState{
  const CounterStateValid(int value) : super(value);

}

class CounterStateInValidNumber extends CounterState{
  final String invalidValue;
  const CounterStateInValidNumber({
    required this.invalidValue,
    required int previousValue,
}) : super(previousValue);
}

//events
@immutable
abstract class CounterEvent{
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent{
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent{
  const DecrementEvent(String value) : super(value);
}

//bloc
class CounterBloc extends Bloc<CounterEvent, CounterState> {

  CounterBloc() : super(const CounterStateValid(0)){
    on<IncrementEvent>((event, emit){
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInValidNumber(
            invalidValue: event.value,
            previousValue: state.value,
        ),
        );
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });

    on<DecrementEvent>((event, emit){
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInValidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ),
        );
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}

*/




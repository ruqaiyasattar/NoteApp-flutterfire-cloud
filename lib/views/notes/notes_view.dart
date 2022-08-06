
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_dart/constant/routes.dart';
import 'package:learning_dart/enums/menu_action.dart';
import 'package:learning_dart/extensions/buildcontext/loc.dart';
import 'package:learning_dart/services/auth/auth_service.dart';
import 'package:learning_dart/services/auth/bloc/auth_bloc.dart';
import 'package:learning_dart/services/auth/bloc/auth_event.dart';
import 'package:learning_dart/services/cloud/cloud_note.dart';
import 'package:learning_dart/services/cloud/firebase_cloud_storage.dart';
import 'package:learning_dart/utility/dialogs/logout_dialog.dart';
import 'package:learning_dart/views/notes/notes_list_view.dart';

extension Count<T extends Iterable> on Stream<T>{
  Stream<int> get getLength => map((event) =>event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  String get userId => AuthService.firebase().currentUser!.id;

  late final FirebaseCLoudStorage _notesService;

  @override
  void initState() {
    _notesService = FirebaseCLoudStorage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId).getLength,
          builder: (context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              final noteCount = snapshot.data ?? 0;
              final text = context.loc.notes_title(noteCount);
              return Text(text);
            } else {
              return const Text('');
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon:const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            itemBuilder: (context){
              return [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text(context.loc.logout_button,))
              ];
            },
            onSelected: (value) async {
              switch(value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
                  }
              }
            },
          )
        ],
      ),

      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note){
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              }  else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

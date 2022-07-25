
import 'package:flutter/material.dart';
import 'package:learning_dart/constant/routes.dart';
import 'package:learning_dart/enums/menu_action.dart';
import 'package:learning_dart/services/auth/auth_service.dart';
import 'package:learning_dart/services/crud/notes_service.dart';
import 'package:learning_dart/utility/dialogs/logout_dialog.dart';
import 'package:learning_dart/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  String get userEmail => AuthService.firebase().currentUser!.email!;

  late final NotesService _notesService;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
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
        title: const Text('Notes'),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon:const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            itemBuilder: (context){
              return const [PopupMenuItem<MenuAction>(value: MenuAction.logout, child: Text('Logout'))];
            },
            onSelected: (value) async {
              switch(value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    if(!mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                          (_) => false,
                    );
                  }
              }
            },
          )
        ],
      ),

      body: FutureBuilder(

        future: _notesService.getOrCreateUser(email: userEmail),

        builder: (context, snapshot) {

          switch(snapshot.connectionState) {

            case ConnectionState.done:

              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return NotesListView(
                          notes: allNotes,
                          onDeleteNote: (note) async {
                            await _notesService.deleteNote(id: note.id);
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
              );
            default:
              return const CircularProgressIndicator();
          }
          },
      ),
    );
  }
}

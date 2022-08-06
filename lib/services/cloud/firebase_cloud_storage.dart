import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_dart/services/cloud/cloud_note.dart';
import 'package:learning_dart/services/cloud/cloud_storage_constants.dart';
import 'package:learning_dart/services/cloud/cloud_storage_exception.dart';

class FirebaseCLoudStorage{
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({ required String documentId}) async {
    try{
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required documentId,
    required String text,
  }) async{
    try{
     await notes.doc(documentId).update({
        textFieldText: text,
      });
    } catch (e){
      throw CouldNotUpdateNoteException();
    }
  }

  //all notes for specific user
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
  notes.snapshots().map((event) => event.docs
      .map((doc) => CloudNote.fromSnapShot(doc))
      .where((note) => note.ownerUserId == ownerUserId),);

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try{
      return await notes.where(
        ownerUserIdFieldName,
        isEqualTo: ownerUserId,
      )
          .get()
          .then((value) => value.docs.map((doc) => CloudNote.fromSnapShot(doc)),
      );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName : ownerUserId,
      textFieldText : '',
    });
    final fetchNote = await document.get();
    return CloudNote(
        documentId: fetchNote.id,
        ownerUserId: ownerUserId,
        text: '',
    );
  }

  static final FirebaseCLoudStorage _shared = FirebaseCLoudStorage._sharedInstance();
  FirebaseCLoudStorage._sharedInstance();
  factory FirebaseCLoudStorage() => _shared;


}
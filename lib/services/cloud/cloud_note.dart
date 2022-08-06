import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'cloud_storage_constants.dart';

@immutable
class CloudNote{
  final String documentId;
  final String ownerUserId;
  final String text;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  CloudNote.fromSnapShot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot):
        documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldText] as String;
}
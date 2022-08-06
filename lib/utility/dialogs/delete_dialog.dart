import 'package:flutter/material.dart';
import 'package:learning_dart/extensions/buildcontext/loc.dart';
import 'package:learning_dart/utility/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(
    BuildContext context,
    ) {
  return showGenericDialog<bool>(
    context: context,
    title: context.loc.delete,
    content: context.loc.delete_note_prompt,
    optionBuilder: () => {
      context.loc.cancel: false,
    context.loc.yes: true,
    },
  ).then((value) => value ?? false,
  );
}



import 'package:flutter/material.dart';
import 'package:learning_dart/extensions/buildcontext/loc.dart';
import 'package:learning_dart/utility/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context){
  return showGenericDialog<void>(
      context: context,
      title: context.loc.password_reset,
      content: context.loc.password_reset_dialog_prompt,
      optionBuilder: () => {
      context.loc.ok: null,
      },
  );
}
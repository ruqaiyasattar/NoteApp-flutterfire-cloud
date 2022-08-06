
import 'package:flutter/widgets.dart';
import 'package:learning_dart/extensions/buildcontext/loc.dart';
import 'package:learning_dart/utility/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
    BuildContext context,
    String text,
    ) {
  return showGenericDialog<void>(
    context: context,
    title: context.loc.generic_error_prompt,
    content: text,
    optionBuilder:() =>{
    context.loc.ok: null,
    },
  );
}
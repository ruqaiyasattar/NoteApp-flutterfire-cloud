
import 'package:flutter/widgets.dart';
import 'package:learning_dart/utility/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
    BuildContext context,
    String text,
    ) {
  return showGenericDialog<void>(
    context: context,
    title: "An error Occurred",
    content: text,
    optionBuilder:() =>{
      'Ok': null,
    },
  );
}
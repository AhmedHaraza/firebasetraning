import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void awesomeDialog({
  required BuildContext context,
  required String description,
  required DialogType dialogType
}) {
  AwesomeDialog(
    context: context,
    dialogType: dialogType,
    animType: AnimType.rightSlide,
    title: 'Dialog Title',
    desc: description,
    btnCancelOnPress: () {},
    btnOkOnPress: () {},
  ).show();
}

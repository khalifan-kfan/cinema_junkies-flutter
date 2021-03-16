import 'package:flutter/material.dart';
import 'package:movies/utils/LoginConfirmation.dart';


class DialogHelper {
  static loging(context) =>
      showDialog(context: context, builder: (context) => LoginConfirmation());
}

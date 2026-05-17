import 'package:flutter/material.dart';

class AppLoader {
  static void showSnackbar(
      BuildContext context, String message, bool isSucess) {
    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isSucess == true ? Colors.green : Colors.red,
      content: Text(
        message,
        //style: AppTheme.snackbarText,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

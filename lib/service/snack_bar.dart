import 'package:flutter/material.dart';

class SnackBarService{
  static Color? errorColor = Colors.red[800];
  static Color? okColor = Colors.green[900];

  static Future<void> showSnackBar(
    BuildContext context, String message,bool error) async {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      final snackBar = SnackBar(
        content: Text(message),
        backgroundColor: error ? errorColor : okColor,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
import 'package:flutter/material.dart';

class Constants{
  static showErrorToast(BuildContext context , String message , {bool isErrorText = true}){

    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      margin: const EdgeInsets.all(20),
      backgroundColor: isErrorText ? Colors.red : Colors.green,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
import 'package:flutter/material.dart';

dynamic snackBar(String message, BuildContext context,
    {int duration = 1500, double fontSize = 16}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: duration),
      content: Text(
        message,
        style: TextStyle(fontSize: fontSize),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

dynamic loadingIndecator(BuildContext context, {bool dismissible = false}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => WillPopScope(
      onWillPop: () {
        return Future.value(dismissible);
      },
      child: const Center(child: CircularProgressIndicator()),
    ),
  );
}

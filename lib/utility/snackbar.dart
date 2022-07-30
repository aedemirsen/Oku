import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, String label) {
  final snackBar = SnackBar(
    content: Text(text),
    action: SnackBarAction(
      label: label,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

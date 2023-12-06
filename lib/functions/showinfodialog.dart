import 'package:flutter/material.dart';

Future<void> showInfoDialog(
    {required String title,
    required String description,
    required BuildContext context}) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

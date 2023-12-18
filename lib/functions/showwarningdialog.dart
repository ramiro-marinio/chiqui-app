import 'package:flutter/material.dart';

Future<void> showWarningDialog(
    {required String title,
    String? description,
    required BuildContext context,
    required VoidCallback yes,
    VoidCallback? no}) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: description != null ? Text(description) : null,
      actions: [
        TextButton(
          onPressed: () {
            if (no != null) {
              no();
            }
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        TextButton(
            onPressed: () {
              yes();
              Navigator.pop(context);
            },
            child: const Text('Yes'))
      ],
    ),
  );
}

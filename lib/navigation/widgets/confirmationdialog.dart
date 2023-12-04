import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? no;
  final VoidCallback? yes;
  const ConfirmationDialog(
      {super.key,
      required this.title,
      required this.description,
      this.no,
      this.yes});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          onPressed: () {
            if (no != null) {
              no!();
            }
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            if (yes != null) {
              yes!();
            }
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}

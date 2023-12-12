import 'package:flutter/material.dart';

Future<void> showProgressDialog(String? title, BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(title ?? 'Saving Demonstration...'),
        content: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator.adaptive()],
        ),
      );
    },
  );
}

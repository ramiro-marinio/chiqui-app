import 'package:flutter/material.dart';

Future<void> showProgressDialog(String title, BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const AlertDialog(
        title: Text('Saving Demonstration...'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator.adaptive()],
        ),
      );
    },
  );
}

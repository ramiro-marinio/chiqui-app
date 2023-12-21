import 'package:flutter/material.dart';

void showAlertSnackbar(
    {required BuildContext context,
    required String text,
    Widget? icon,
    Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Visibility(
            visible: icon != null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon ?? const Placeholder(),
            ),
          ),
          Text(text),
        ],
      ),
      duration: duration ?? const Duration(seconds: 3),
    ),
  );
}

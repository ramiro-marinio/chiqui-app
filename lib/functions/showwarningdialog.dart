import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showWarningDialog(
    {required String title,
    String? description,
    required BuildContext context,
    required VoidCallback yes,
    VoidCallback? no}) async {
  AppLocalizations appLocalizations = AppLocalizations.of(context)!;
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
          child: Text(appLocalizations.no),
        ),
        TextButton(
          onPressed: () {
            yes();
            Navigator.pop(context);
          },
          child: Text(appLocalizations.yes),
        )
      ],
    ),
  );
}

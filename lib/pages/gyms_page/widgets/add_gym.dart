import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddGymButton extends StatelessWidget {
  final VoidCallback onJoinGym;
  final VoidCallback onCreateGym;
  const AddGymButton(
      {super.key, required this.onJoinGym, required this.onCreateGym});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: Text(appLocalizations.joinGym),
            onTap: () {
              onJoinGym();
            },
          ),
          PopupMenuItem(
            child: Text(appLocalizations.createGym),
            onTap: () {
              onCreateGym();
            },
          ),
        ];
      },
    );
  }
}

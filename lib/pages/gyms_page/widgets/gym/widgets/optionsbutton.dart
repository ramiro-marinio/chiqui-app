import 'package:flutter/material.dart';
import 'package:gymapp/widgets/icontext.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OptionsButton extends StatelessWidget {
  final VoidCallback? leaveGym;
  final VoidCallback rateGym;
  const OptionsButton(
      {super.key, required this.leaveGym, required this.rateGym});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: IconText(
                icon: const Icon(Icons.star),
                text: appLocalizations.gymRatings),
            onTap: () {
              rateGym();
            },
          ),
          PopupMenuItem(
            onTap: leaveGym != null
                ? () {
                    leaveGym!();
                  }
                : null,
            child: IconText(
                icon: const Icon(Icons.close), text: appLocalizations.leave),
          ),
        ];
      },
    );
  }
}

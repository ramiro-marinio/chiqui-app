import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavTile extends StatelessWidget {
  final bool mustBeLoggedIn;
  final Widget icon;
  final String title;
  final String path;
  const NavTile({
    super.key,
    required this.mustBeLoggedIn,
    required this.title,
    required this.path,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    Widget? errorMessage;
    if (mustBeLoggedIn && !applicationState.loggedIn) {
      errorMessage = Text(appLocalizations.mustBeLoggedIn);
    } else if (mustBeLoggedIn &&
        (applicationState.user?.emailVerified ?? false) == false) {
      errorMessage = Text(appLocalizations.emailNotVerified);
    }
    return ListTile(
      enabled: errorMessage == null,
      leading: icon,
      title: Text(title),
      onTap: errorMessage == null
          ? () {
              context.go(path);
            }
          : null,
      subtitle: errorMessage,
    );
  }
}

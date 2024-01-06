import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:provider/provider.dart';

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
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: !mustBeLoggedIn || applicationState.loggedIn
          ? () {
              context.go(path);
            }
          : null,
      subtitle: mustBeLoggedIn && !applicationState.loggedIn
          ? const Text('Must be logged in.')
          : null,
      splashColor: const Color.fromARGB(35, 0, 155, 255),
    );
  }
}

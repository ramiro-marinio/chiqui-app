import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/firebase/widgets/profile.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/navigation/widgets/navtile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List<NavTile> links = [];
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    links = [
      NavTile(
        mustBeLoggedIn: false,
        title: appLocalizations.homePage,
        path: '/',
        icon: const Icon(CupertinoIcons.home),
      ),
      NavTile(
        mustBeLoggedIn: true,
        title: appLocalizations.myGyms,
        path: '/my-gyms',
        icon: const Icon(CupertinoIcons.list_bullet),
      ),
      // NavTile(
      //   mustBeLoggedIn: false,
      //   title: appLocalizations.help,
      //   path: '/help',
      //   icon: const Icon(Icons.help),
      // ),
      NavTile(
        mustBeLoggedIn: true,
        title: appLocalizations.sendSuggestion,
        path: '/suggestion',
        icon: const Icon(CupertinoIcons.lightbulb),
      ),
      NavTile(
        mustBeLoggedIn: false,
        title: appLocalizations.settings,
        path: '/settings',
        icon: const Icon(CupertinoIcons.settings_solid),
      ),
    ];
    return Drawer(
      child: ListView(
        children: [
          const Profile(),
          Divider(
            thickness: 1,
            color: adaptiveColor(Colors.black, Colors.white, context),
            indent: 8,
            endIndent: 8,
          ),
          ...List.generate(
            links.length,
            (index) => Column(
              children: [
                links[index],
                const AdaptiveDivider(
                  indent: 8,
                  thickness: 0.2,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

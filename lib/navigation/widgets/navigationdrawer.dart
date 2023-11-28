import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/firebase/widgets/profilelisttile.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/navigation/widgets/gorouter.dart';
import 'package:gymapp/navigation/widgets/icongoroute.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    List<ListTile> links = [];
    for (GoRoute goRoute in routes) {
      if (goRoute.runtimeType == IconGoRoute) {
        links += [
          ListTile(
            leading: (goRoute as IconGoRoute).icon,
            title: Text(goRoute.name ?? ""),
            onTap: !goRoute.mustBeLoggedIn || applicationState.loggedIn
                ? () {
                    context.go(goRoute.path);
                  }
                : null,
            subtitle: Visibility(
              visible: goRoute.mustBeLoggedIn && !applicationState.loggedIn,
              child: const Text("Must be logged in."),
            ),
            splashColor: const Color.fromARGB(35, 0, 155, 255),
          )
        ];
      }
    }
    return Drawer(
      child: ListView(children: [
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
              )
            ],
          ),
        ),
      ]),
    );
  }
}

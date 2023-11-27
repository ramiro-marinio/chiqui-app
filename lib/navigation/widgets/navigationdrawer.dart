import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/widgets/profilelisttile.dart';
import 'package:gymapp/navigation/widgets/gorouter.dart';
import 'package:gymapp/navigation/widgets/icongoroute.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List<ListTile> links = [];
    for (GoRoute goRoute in routes) {
      if (goRoute.runtimeType == IconGoRoute) {
        links += [
          ListTile(
            leading: (goRoute as IconGoRoute).icon,
            title: Text(goRoute.name ?? ""),
            onTap: () {
              context.go(goRoute.path);
            },
            splashColor: const Color.fromARGB(35, 0, 155, 255),
          )
        ];
      }
    }
    return Drawer(
      child: ListView(children: [
        const Profile(),
        const Divider(
          thickness: 1,
          color: Colors.black,
          indent: 8,
          endIndent: 8,
        ),
        ...links
      ]),
    );
  }
}

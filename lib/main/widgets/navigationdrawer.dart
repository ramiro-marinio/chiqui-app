import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/main/widgets/gorouter.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        itemCount: routes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: routes[index].icon,
            title: Text(routes[index].name ?? ""),
            onTap: () {
              context.go(routes[index].path);
            },
            splashColor: const Color.fromARGB(35, 0, 155, 255),
          );
        },
      ),
    );
  }
}

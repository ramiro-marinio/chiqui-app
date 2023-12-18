import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/widgets/profile_config/profileconfig.dart';
import 'package:gymapp/firebase/widgets/icontext.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    return GestureDetector(
      child: ListTile(
        leading: Builder(builder: (context) {
          ImageProvider imageProvider = applicationState.loggedIn &&
                  applicationState.user?.photoURL != null
              ? NetworkImage(applicationState.user!.photoURL!)
              : const AssetImage('assets/no_image.jpg') as ImageProvider;
          return CircleAvatar(
            radius: 25,
            backgroundImage: imageProvider,
          );
        }),
        title: applicationState.loggedIn
            ? const Text('Your account')
            : const Text('No account'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            applicationState.loggedIn
                ? AutoSizeText(
                    applicationState.user!.email ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                : const AutoSizeText(
                    "Tap to log in (or register)",
                    maxLines: 1,
                  ),
            Visibility(
              visible: applicationState.loggedIn,
              child: const Text("Long tap for more options"),
            )
          ],
        ),
        isThreeLine: applicationState.loggedIn,
        onTap: applicationState.loggedIn
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileConfig(),
                  ),
                );
              }
            : () {
                context.push("/sign-in");
              },
      ),
      onLongPressStart: (details) {
        if (applicationState.loggedIn) {
          showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                  details.globalPosition.dx,
                  details.globalPosition.dy,
                  details.globalPosition.dx,
                  details.globalPosition.dy),
              items: [
                PopupMenuItem(
                  child: const IconText(
                      icon: Icon(Icons.exit_to_app), text: "Log Out"),
                  onTap: () {
                    applicationState.signOut();
                    context.push('/sign-in');
                  },
                ),
              ]);
        }
      },
    );
  }
}

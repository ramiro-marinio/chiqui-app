import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/widgets/profile_config/profileconfig.dart';
import 'package:gymapp/widgets/icontext.dart';
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
          if (!applicationState.loading) {
            ImageProvider imageProvider =
                const AssetImage('assets/no_image.jpg');
            if (applicationState.loggedIn &&
                applicationState.user!.photoURL != null) {
              imageProvider = NetworkImage(applicationState.user!.photoURL!);
            }
            return CircleAvatar(
              radius: 25,
              backgroundImage: imageProvider,
            );
          } else {
            return const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator.adaptive(),
            );
          }
        }),
        title: applicationState.loggedIn
            ? const Text('Your account')
            : const Text('No account'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            applicationState.loggedIn
                ? AutoSizeText(
                    applicationState.user!.email!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                : !applicationState.loading
                    ? const AutoSizeText(
                        "Tap to log in (or register)",
                        maxLines: 1,
                      )
                    : const AutoSizeText(
                        "Loading...",
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
            : !applicationState.loading
                ? () {
                    context.push("/sign-in");
                  }
                : null,
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

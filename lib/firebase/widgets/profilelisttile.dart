import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, applicationState, child) {
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: applicationState.loggedIn
                ? const AssetImage("assets/no_image_gym.jpg")
                : const AssetImage("assets/no_image.jpg"),
          ),
          title: applicationState.loggedIn
              ? const Text("Your account")
              : const Text("No account"),
          subtitle: applicationState.loggedIn
              ? const AutoSizeText(
                  "ramiro.marinho0@gmail.com",
                  maxLines: 1,
                )
              : const AutoSizeText(
                  "Tap to log in (or register)",
                  maxLines: 1,
                ),
          onTap: applicationState.loggedIn
              ? () {}
              : () {
                  context.push("/sign-in");
                },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/widgets/mustbeloggedin.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';
import 'package:provider/provider.dart';

class ProfileConfig extends StatefulWidget {
  const ProfileConfig({super.key});

  @override
  State<ProfileConfig> createState() => _ProfileConfigState();
}

class _ProfileConfigState extends State<ProfileConfig> {
  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    return applicationState.loggedIn
        ? Scaffold(
            drawer: const NavDrawer(),
            appBar: AppBar(title: const Text("Configure Profile")),
            body: const Column(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage("assets/no_image.jpg"),
                )
              ],
            ),
          )
        : const MustBeLoggedIn();
  }
}

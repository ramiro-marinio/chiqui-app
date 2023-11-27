import 'package:flutter/material.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';

class MustBeLoggedIn extends StatelessWidget {
  const MustBeLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(title: const Text("Must be logged in.")),
      body: const Center(
        child: Text("You must be logged in to configure your profile."),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AddGymButton extends StatelessWidget {
  final VoidCallback onJoinGym;
  final VoidCallback onCreateGym;
  const AddGymButton(
      {super.key, required this.onJoinGym, required this.onCreateGym});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: const Text("Join a Gym"),
            onTap: () {
              onJoinGym();
            },
          ),
          PopupMenuItem(
            child: const Text("Create a Gym"),
            onTap: () {
              onCreateGym();
            },
          ),
        ];
      },
    );
  }
}

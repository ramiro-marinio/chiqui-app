import 'package:flutter/material.dart';
import 'package:gymapp/firebase/widgets/icontext.dart';

class OptionsButton extends StatelessWidget {
  final VoidCallback leaveGym;
  final VoidCallback rateGym;
  const OptionsButton(
      {super.key, required this.leaveGym, required this.rateGym});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            child: const IconText(icon: Icon(Icons.star), text: "Rate gym"),
            onTap: () {
              rateGym();
            },
          ),
          PopupMenuItem(
            child: const IconText(icon: Icon(Icons.close), text: "Leave"),
            onTap: () {
              leaveGym();
            },
          ),
        ];
      },
    );
  }
}

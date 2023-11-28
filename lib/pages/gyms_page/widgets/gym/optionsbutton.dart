import 'package:flutter/material.dart';
import 'package:gymapp/firebase/widgets/icontext.dart';

class OptionsButton extends StatelessWidget {
  const OptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            child: IconText(icon: Icon(Icons.star), text: "Rate gym"),
          ),
          const PopupMenuItem(
            child: IconText(icon: Icon(Icons.close), text: "Leave"),
          ),
        ];
      },
    );
  }
}

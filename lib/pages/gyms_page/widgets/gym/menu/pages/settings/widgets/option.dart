import 'package:flutter/material.dart';

class Option extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onTap;
  const Option(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(text),
      onTap: onTap,
    );
  }
}

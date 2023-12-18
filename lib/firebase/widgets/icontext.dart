import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final Widget icon;
  final String text;
  const IconText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          icon,
          AutoSizeText(
            text,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gymapp/functions/adaptive_color.dart';

class IconText extends StatelessWidget {
  final Widget icon;
  final String text;
  const IconText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: icon,
                ),
              ],
            ),
          ),
          TextSpan(
              text: text,
              style: TextStyle(
                  color: adaptiveColor(Colors.black, Colors.white, context))),
        ],
      ),
    );
  }
}

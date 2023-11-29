import 'package:flutter/material.dart';
import 'package:gymapp/functions/adaptive_color.dart';

class AdaptiveDivider extends StatelessWidget {
  final double? indent;
  final double? thickness;
  const AdaptiveDivider({super.key, this.indent, this.thickness});

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: indent ?? 25,
      endIndent: indent ?? 25,
      color: adaptiveColor(Colors.black, Colors.white, context),
      thickness: thickness ?? 0.5,
    );
  }
}

import 'package:flutter/material.dart';

Color adaptiveColor(Color lightColor, Color darkColor, BuildContext context) {
  bool lightMode =
      Theme.of(context).brightness == Brightness.light ? true : false;
  return lightMode ? lightColor : darkColor;
}

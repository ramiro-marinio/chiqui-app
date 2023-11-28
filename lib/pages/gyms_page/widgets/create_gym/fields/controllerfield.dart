import 'package:flutter/material.dart';

class ControllerField extends StatelessWidget {
  final Widget icon;
  final String title;
  final int? maxLines;
  final TextEditingController controller;
  const ControllerField({
    super.key,
    required this.controller,
    required this.title,
    required this.icon,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: icon,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 200,
          child: TextField(
            maxLines: maxLines,
            controller: controller,
          ),
        ),
      ],
    );
  }
}

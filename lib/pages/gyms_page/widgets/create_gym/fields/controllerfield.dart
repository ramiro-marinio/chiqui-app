import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ControllerField extends StatelessWidget {
  final Widget icon;
  final String title;
  final int? maxLines;
  final int maxLength;
  final TextEditingController controller;
  const ControllerField({
    super.key,
    required this.controller,
    required this.title,
    required this.icon,
    required this.maxLength,
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
            AutoSizeText(
              title,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(maxLines != null ? 8.0 : 0.0),
          child: SizedBox(
            width: maxLines != null ? double.infinity : 200,
            child: TextField(
              decoration: InputDecoration(
                border: maxLines != null
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey))
                    : null,
              ),
              maxLines: maxLines,
              maxLength: maxLength,
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }
}

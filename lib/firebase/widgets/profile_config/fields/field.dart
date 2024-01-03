import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? initialText;
  final int? maxLength;
  final int? maxLines;
  final String? hintText;
  final Function(String) onChanged;
  const Field(
      {super.key,
      required this.title,
      required this.icon,
      this.initialText,
      required this.onChanged,
      this.maxLength,
      this.maxLines,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: icon,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: maxLines != null ? double.infinity : 350,
            child: TextField(
              maxLength: maxLength,
              maxLines: maxLines,
              decoration: InputDecoration(
                border: maxLines != null ? const OutlineInputBorder() : null,
                hintText: hintText,
              ),
              controller: TextEditingController(text: initialText),
              onChanged: (value) {
                onChanged(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}

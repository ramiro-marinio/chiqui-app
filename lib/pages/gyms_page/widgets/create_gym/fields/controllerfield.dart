import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ControllerField extends StatelessWidget {
  final Widget icon;
  final String title;
  final int? maxLines;
  final int maxLength;
  final bool showMaxlength;
  final TextEditingController controller;
  final String? Function(String? value)? validator;
  const ControllerField(
      {super.key,
      required this.controller,
      required this.title,
      required this.icon,
      required this.maxLength,
      this.maxLines,
      this.validator,
      this.showMaxlength = true});

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
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              validator: validator,
              decoration: InputDecoration(
                border: maxLines != null
                    ? OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey))
                    : null,
              ),
              maxLines: maxLines,
              maxLength: showMaxlength ? maxLength : null,
              inputFormatters: [
                if (!showMaxlength) LengthLimitingTextInputFormatter(maxLength)
              ],
              controller: controller,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class LengthInputDialog extends StatefulWidget {
  final int chars;
  final void Function(int val) onComplete;
  const LengthInputDialog(
      {super.key, required this.chars, required this.onComplete});

  @override
  State<LengthInputDialog> createState() => _LengthInputDialogState();
}

class _LengthInputDialogState extends State<LengthInputDialog> {
  int? length;
  @override
  Widget build(BuildContext context) {
    length ??= widget.chars;
    return AlertDialog(
      title: const Text('Pick a code length'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: length!.toDouble(),
                  max: 25,
                  min: 7,
                  onChanged: (value) {
                    setState(() {
                      length = value.toInt();
                    });
                  },
                ),
              ),
              SizedBox(
                width: 80,
                child: Text(
                  '$length chars',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onComplete(length!);
            Navigator.pop(context);
          },
          child: const Text('Choose'),
        )
      ],
    );
  }
}

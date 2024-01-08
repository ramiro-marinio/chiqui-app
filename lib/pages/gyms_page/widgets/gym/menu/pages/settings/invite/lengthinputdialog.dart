import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gymapp/functions/calculate_text_size.dart';

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
    final appLocalizations = AppLocalizations.of(context)!;
    length ??= widget.chars;
    return AlertDialog(
      title: Text(appLocalizations.pickCodeLength),
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
                width: calculateTextSize(
                      appLocalizations.characters(10),
                      const TextStyle(
                        fontSize: 18,
                      ),
                    ).width +
                    10,
                child: Text(
                  appLocalizations.characters(length ?? 0),
                  textAlign: TextAlign.left,
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

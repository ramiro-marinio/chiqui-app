import 'package:flutter/material.dart';
import 'package:gymapp/functions/adaptive_color.dart';

class SwitchField extends StatefulWidget {
  final String? title;
  final Widget? icon;
  final String? valA;
  final String? valB;
  final bool value;
  final List<Color>? thumbColors;
  final List<Color>? trackColors;
  final Function(bool value) onChange;
  const SwitchField({
    super.key,
    required this.value,
    required this.onChange,
    this.title,
    this.icon,
    this.valA,
    this.valB,
    this.thumbColors,
    this.trackColors,
  });

  @override
  State<SwitchField> createState() => _SwitchFieldState();
}

class _SwitchFieldState extends State<SwitchField> {
  bool? val;
  @override
  Widget build(BuildContext context) {
    val ??= widget.value;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.icon ??
                  const Row(
                    children: [Icon(Icons.female), Icon(Icons.male)],
                  ),
            ),
            Text(
              widget.title ?? 'Biological Sex',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.valA ?? 'Male'),
            Switch(
              value: val!,
              onChanged: (value) {
                setState(() {
                  val = value;
                });
                widget.onChange(value);
              },
              activeColor: widget.thumbColors?[1] ??
                  adaptiveColor(const Color.fromARGB(255, 186, 77, 179),
                      const Color.fromARGB(255, 222, 111, 214), context),
              inactiveThumbColor: widget.thumbColors?[0] ??
                  const Color.fromARGB(255, 17, 74, 121),
              trackColor: MaterialStateColor.resolveWith(
                (states) => !val!
                    ? (widget.trackColors?[0] ?? Colors.blue)
                    : (widget.trackColors?[1] ??
                        adaptiveColor(const Color.fromARGB(255, 116, 48, 111),
                            const Color.fromARGB(255, 103, 52, 100), context)),
              ),
            ),
            Text(widget.valB ?? 'Female'),
          ],
        )
      ],
    );
  }
}

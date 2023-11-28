import 'package:flutter/material.dart';
import 'package:gymapp/functions/adaptive_color.dart';

class GenderField extends StatefulWidget {
  final bool value;
  final Function(bool value) onChange;
  const GenderField({super.key, required this.value, required this.onChange});

  @override
  State<GenderField> createState() => _GenderFieldState();
}

class _GenderFieldState extends State<GenderField> {
  bool? val;
  @override
  Widget build(BuildContext context) {
    val ??= widget.value;
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [Icon(Icons.female), Icon(Icons.male)],
              ),
            ),
            Text(
              "Biological Sex",
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Male"),
            Switch(
              value: val!,
              onChanged: (value) {
                setState(() {
                  val = value;
                });
                widget.onChange(value);
              },
              activeColor: adaptiveColor(
                  const Color.fromARGB(255, 186, 77, 179),
                  const Color.fromARGB(255, 222, 111, 214),
                  context),
              inactiveThumbColor: const Color.fromARGB(255, 17, 74, 121),
              trackColor: MaterialStateColor.resolveWith(
                (states) => !val!
                    ? Colors.blue
                    : adaptiveColor(const Color.fromARGB(255, 116, 48, 111),
                        const Color.fromARGB(255, 103, 52, 100), context),
              ),
            ),
            const Text("Female"),
          ],
        )
      ],
    );
  }
}

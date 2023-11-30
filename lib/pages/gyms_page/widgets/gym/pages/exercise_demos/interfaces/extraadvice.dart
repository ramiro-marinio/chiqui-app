import 'package:flutter/material.dart';

class ExtraAdviceField extends StatelessWidget {
  final Function(String text) onChange;
  const ExtraAdviceField({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.library_books),
              ),
              Text(
                "Extra Advice",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              onChange(value);
            },
            maxLength: 1000,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Technique advice, caution measures, etc...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

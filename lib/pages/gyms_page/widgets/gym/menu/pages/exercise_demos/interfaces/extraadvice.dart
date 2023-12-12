import 'package:flutter/material.dart';

class ExerciseAdviceField extends StatelessWidget {
  final TextEditingController controller;
  const ExerciseAdviceField({super.key, required this.controller});

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
                "Exercise Advice",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            maxLength: 1000,
            maxLines: 4,
            controller: controller,
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

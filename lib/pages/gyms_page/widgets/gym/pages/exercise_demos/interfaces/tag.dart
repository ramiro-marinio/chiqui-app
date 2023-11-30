import 'package:flutter/material.dart';
import 'package:gymapp/functions/adaptive_color.dart';

class Tag extends StatelessWidget {
  final String text;
  final VoidCallback remove;
  const Tag({super.key, required this.text, required this.remove});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: adaptiveColor(const Color.fromARGB(255, 0, 0, 100),
          const Color.fromARGB(255, 63, 63, 121), context),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    text,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Center(
                    child: IconButton(
                      color: Colors.white,
                      iconSize: 20,
                      onPressed: () {
                        remove();
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

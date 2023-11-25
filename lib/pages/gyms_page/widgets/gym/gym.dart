import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/optionsbutton.dart';

class Gym extends StatefulWidget {
  final String? imageUrl;
  final String name;
  const Gym({super.key, this.imageUrl, required this.name});

  @override
  State<Gym> createState() => _GymState();
}

class _GymState extends State<Gym> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 180, 200, 255),
      child: SizedBox(
        child: Stack(children: [
          const Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "OWNED BY YOU",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: widget.imageUrl != null
                      ? NetworkImage(
                          widget.imageUrl!,
                        )
                      : const AssetImage("assets/no_image.jpg")
                          as ImageProvider,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: AutoSizeText(
                    widget.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 25),
                  ),
                ),
              ),
              Tooltip(
                message: "Enter to gym's menu",
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.exit_to_app),
                ),
              ),
              const OptionsButton(),
            ],
          ),
        ]),
      ),
    );
  }
}

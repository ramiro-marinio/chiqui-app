import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/optionsbutton.dart';

class GymView extends StatefulWidget {
  final GymData gymData;
  const GymView({super.key, required this.gymData});

  @override
  State<GymView> createState() => _GymViewState();
}

class _GymViewState extends State<GymView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Card(
        color: adaptiveColor(const Color.fromARGB(255, 180, 200, 255),
            const Color.fromARGB(255, 54, 77, 142), context),
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
                    backgroundImage: widget.gymData.photoURL != null
                        ? NetworkImage(
                            widget.gymData.photoURL!,
                          )
                        : const AssetImage("assets/no_image_gym.jpg")
                            as ImageProvider,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: AutoSizeText(
                      widget.gymData.name,
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
      ),
    );
  }
}

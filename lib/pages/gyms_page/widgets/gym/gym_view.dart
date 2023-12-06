import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/optionsbutton.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/gymmenu.dart';
import 'package:gymapp/pages/gyms_page/widgets/rating/rate_gym.dart';
import 'package:provider/provider.dart';

class GymView extends StatefulWidget {
  final GymData gymData;
  const GymView({super.key, required this.gymData});

  @override
  State<GymView> createState() => _GymViewState();
}

class _GymViewState extends State<GymView> {
  Future<double?>? rating;
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, applicationState, child) {
      rating ??= applicationState.getRating(widget.gymData.id!);
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Card(
          color: adaptiveColor(const Color.fromARGB(255, 180, 200, 255),
              const Color.fromARGB(255, 54, 77, 142), context),
          child: SizedBox(
            child: Stack(children: [
              Visibility(
                visible: widget.gymData.ownerId == applicationState.user!.uid,
                child: const Positioned(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "OWNED BY YOU",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  right: 10,
                  top: 2,
                  child: FutureBuilder(
                    future: rating,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Visibility(
                          visible: snapshot.data != null,
                          child: Row(children: [
                            RatingBarIndicator(
                              rating: snapshot.data ?? 5,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: adaptiveColor(
                                    const Color.fromARGB(255, 100, 77, 0),
                                    Colors.amber,
                                    context),
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                          ]),
                        );
                      } else {
                        return const CircularProgressIndicator.adaptive();
                      }
                    },
                  )),
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GymMenu(
                                gymData: widget.gymData,
                              ),
                            ));
                      },
                      icon: const Icon(Icons.exit_to_app),
                    ),
                  ),
                  OptionsButton(
                    rateGym: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RateGym(
                            gymData: widget.gymData,
                          ),
                        ),
                      );
                    },
                    leaveGym: () {},
                  ),
                ],
              ),
            ]),
          ),
        ),
      );
    });
  }
}

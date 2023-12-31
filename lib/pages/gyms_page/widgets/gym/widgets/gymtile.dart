import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/functions/showinfodialog.dart';
import 'package:gymapp/functions/showwarningdialog.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/widgets/optionsbutton.dart';
import 'package:gymapp/pages/gyms_page/widgets/rating/viewpage/view_rating_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GymTile extends StatefulWidget {
  final GymData gymData;
  const GymTile({super.key, required this.gymData});

  @override
  State<GymTile> createState() => _GymTileState();
}

class _GymTileState extends State<GymTile> {
  Future<double?>? rating;
  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Consumer<ApplicationState>(
        builder: (context, applicationState, child) {
      rating ??= applicationState.getRatingAvg(widget.gymData.id!);
      return Padding(
        padding: const EdgeInsets.only(top: 8, right: 4, left: 4),
        child: Card(
          color: adaptiveColor(const Color.fromARGB(255, 132, 164, 255),
              const Color.fromARGB(255, 54, 77, 142), context),
          child: SizedBox(
            child: Stack(children: [
              Visibility(
                visible: widget.gymData.ownerId == applicationState.user!.uid,
                child: Positioned(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        appLocalizations.ownedByYou,
                        style: const TextStyle(
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
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
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
                    message: appLocalizations.enterGymMenu,
                    child: IconButton(
                      onPressed: () {
                        context.push('/my-gyms/gym-menu',
                            extra: widget.gymData);
                      },
                      icon: const Icon(Icons.exit_to_app),
                    ),
                  ),
                  OptionsButton(
                    rateGym: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewRatingPage(
                            gymData: widget.gymData,
                          ),
                        ),
                      );
                    },
                    leaveGym:
                        applicationState.user!.uid != widget.gymData.ownerId
                            ? () {
                                showWarningDialog(
                                  title: appLocalizations.leavePrompt,
                                  context: context,
                                  yes: () async {
                                    await applicationState
                                        .leaveGym(widget.gymData.id!);
                                  },
                                );
                              }
                            : () {
                                showInfoDialog(
                                    title: appLocalizations.generalError,
                                    description: appLocalizations.cantLeave,
                                    context: context);
                              },
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

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/functions/showinfodialog.dart';
import 'package:gymapp/functions/showwarningdialog.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/widgets/optionsbutton.dart';
import 'package:gymapp/pages/gyms_page/widgets/rating/viewpage/view_rating_page.dart';
import 'package:gymapp/widgets/zoomavatar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GymTile extends StatefulWidget {
  final MembershipData membership;
  const GymTile({super.key, required this.membership});

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
      Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
          .instance
          .collection('gyms')
          .where('id', isEqualTo: widget.membership.gymId)
          .snapshots();
      rating ??= applicationState.getRatingAvg(widget.membership.gymId);
      return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator.adaptive()],
            );
          }
          GymData gymData = GymData.fromJson(snapshot.data!.docs[0].data());
          return Padding(
            padding: const EdgeInsets.only(top: 8, right: 4, left: 4),
            child: SizedBox(
              height: 100,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                shadowColor: Colors.transparent,
                color: adaptiveColor(const Color.fromARGB(255, 232, 232, 232),
                    const Color.fromARGB(255, 36, 36, 37), context),
                child: Stack(children: [
                  Visibility(
                    visible: gymData.ownerId == applicationState.user!.uid ||
                        !widget.membership.accepted,
                    child: Positioned(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            !widget.membership.accepted
                                ? appLocalizations.notAccepted
                                : appLocalizations.ownedByYou,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: !widget.membership.accepted
                                  ? Colors.red
                                  : null,
                            ),
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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
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
                  SizedBox(
                    height: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ZoomAvatar(
                            radius: 32,
                            photoURL: gymData.photoURL,
                            gymImage: true,
                            tag: UniqueKey().toString(),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: AutoSizeText(
                              gymData.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 25,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ),
                        Tooltip(
                          message: appLocalizations.enterGymMenu,
                          child: SizedBox(
                            width: 40,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: IconButton(
                                onPressed: widget.membership.accepted
                                    ? () {
                                        context.push('/my-gyms/gym-menu',
                                            extra: gymData);
                                      }
                                    : null,
                                icon: const Icon(
                                    CupertinoIcons.square_arrow_right),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OptionsButton(
                            rateGym: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewRatingPage(
                                    gymData: gymData,
                                  ),
                                ),
                              );
                            },
                            leaveGym: applicationState.user!.uid !=
                                    gymData.ownerId
                                ? () {
                                    showWarningDialog(
                                      title: appLocalizations.leavePrompt,
                                      context: context,
                                      yes: () async {
                                        await applicationState
                                            .leaveGym(gymData.id!);
                                      },
                                    );
                                  }
                                : () {
                                    showInfoDialog(
                                      title: appLocalizations.generalError,
                                      description: appLocalizations.cantLeave,
                                      context: context,
                                    );
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
      );
    });
  }
}

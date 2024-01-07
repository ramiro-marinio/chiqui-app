import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/gyms/membershipdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/settings/settings.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/chat/my_chats.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/exercisedemos.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/info/gyminfo.dart';
import 'package:gymapp/widgets/crawl.dart';
import 'package:gymapp/widgets/zoomavatar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GymMenu extends StatefulWidget {
  final GymData gymData;
  const GymMenu({super.key, required this.gymData});

  @override
  State<GymMenu> createState() => GymMenuState();
}

class GymMenuState extends State<GymMenu> {
  Future<MembershipData>? membershipData;
  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    membershipData ??= applicationState.getMembership(
        widget.gymData.id!, applicationState.user!.uid);
    return DefaultTabController(
      length: 3,
      animationDuration: const Duration(milliseconds: 300),
      initialIndex: 0,
      child: FutureBuilder(
        future: membershipData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ZoomAvatar(
                      radius: 20,
                      photoURL: widget.gymData.photoURL,
                    ),
                  ),
                  Expanded(
                    child: Crawl(
                      child: Text(widget.gymData.name),
                    ),
                  )
                ]),
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: const Icon(Icons.info),
                      text: appLocalizations.gymInfo,
                    ),
                    const Tab(
                      icon: Icon(Icons.chat),
                      text: 'Chat',
                    ),
                    Tab(
                      icon: const Icon(Icons.fitness_center),
                      text: appLocalizations.exercisesInfo,
                    ),
                  ],
                ),
                actions: [
                  Visibility(
                    visible:
                        applicationState.user!.uid == widget.gymData.ownerId ||
                            snapshot.data!.admin ||
                            snapshot.data!.coach,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(
                              gymData: widget.gymData,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings),
                    ),
                  )
                ],
              ),
              body: TabBarView(
                children: [
                  GymInfo(gymData: widget.gymData),
                  MyChats(
                    gymData: widget.gymData,
                  ),
                  ExerciseDemonstrations(
                    gymData: widget.gymData,
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
    );
  }
}

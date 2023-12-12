import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/pages/gyms_page/settings/settings.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/chat/my_chats.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/exercisedemos.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/info/gyminfo.dart';
import 'package:gymapp/widgets/crawltext.dart';
import 'package:provider/provider.dart';

class GymMenu extends StatefulWidget {
  final GymData gymData;
  const GymMenu({super.key, required this.gymData});

  @override
  State<GymMenu> createState() => GymMenuState();
}

class GymMenuState extends State<GymMenu> {
  @override
  Widget build(BuildContext context) {
    ApplicationState applicationState = Provider.of<ApplicationState>(context);
    return DefaultTabController(
      length: 3,
      animationDuration: const Duration(milliseconds: 300),
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: widget.gymData.photoURL != null
                    ? NetworkImage(widget.gymData.photoURL!)
                    : const AssetImage('assets/no_image_gym.jpg')
                        as ImageProvider,
              ),
            ),
            Expanded(
              child: Crawl(
                child: Text(widget.gymData.name),
              ),
            )
          ]),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.info),
                text: 'Gym Info',
              ),
              Tab(
                icon: Icon(Icons.chat),
                text: 'Chat',
              ),
              Tab(
                icon: Icon(Icons.fitness_center),
                text: 'Exercises Info',
              ),
            ],
          ),
          actions: [
            Visibility(
              visible: applicationState.user!.uid == widget.gymData.ownerId,
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
        body: TabBarView(children: [
          GymInfo(gymData: widget.gymData),
          MyChats(gymData: widget.gymData),
          ExerciseDemonstrations(
            gymData: widget.gymData,
          ),
        ]),
      ),
    );
  }
}

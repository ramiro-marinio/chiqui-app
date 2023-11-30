import 'package:flutter/material.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/chat.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/exercisedemos.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/gyminfo.dart';

class GymMenu extends StatefulWidget {
  final GymData gymData;
  const GymMenu({super.key, required this.gymData});

  @override
  State<GymMenu> createState() => GymMenuState();
}

class GymMenuState extends State<GymMenu> {
  @override
  Widget build(BuildContext context) {
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
            Text(widget.gymData.name)
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
        ),
        body: TabBarView(children: [
          GymInfo(gymData: widget.gymData),
          const Chat(),
          ExerciseDemonstrations(
            gymId: widget.gymData.id!,
          ),
        ]),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';
import 'package:gymapp/pages/gyms_page/widgets/add_gym.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/creategym.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/widgets/gym_view.dart';
import 'package:gymapp/pages/gyms_page/widgets/join_gym/join_gym.dart';
import 'package:provider/provider.dart';

class MyGyms extends StatefulWidget {
  const MyGyms({super.key});

  @override
  State<MyGyms> createState() => _MyGymsState();
}

class _MyGymsState extends State<MyGyms> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, applicationState, child) {
      List<GymData> gymData = applicationState.gyms!;
      return Scaffold(
          drawer: const NavDrawer(),
          appBar: AppBar(
            title: const Text('My Gyms'),
            actions: [
              AddGymButton(
                onJoinGym: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JoinGym(),
                    ),
                  );
                },
                onCreateGym: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateGym(),
                    ),
                  );
                },
              )
            ],
          ),
          body: ListView(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      'My Gyms',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              ...List.generate(
                gymData.length,
                (index) => GymView(
                  gymData: gymData[index],
                ),
              ),
            ],
          ));
    });
  }
}

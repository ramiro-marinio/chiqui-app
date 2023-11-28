import 'package:flutter/material.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';
import 'package:gymapp/pages/gyms_page/widgets/add_gym.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/creategym.dart';

class MyGyms extends StatefulWidget {
  const MyGyms({super.key});

  @override
  State<MyGyms> createState() => _MyGymsState();
}

class _MyGymsState extends State<MyGyms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text("My Gyms"),
        actions: [
          AddGymButton(
            onJoinGym: () {},
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
      // ignore: prefer_const_constructors
      body: Column(
        children: const [],
      ),
    );
  }
}

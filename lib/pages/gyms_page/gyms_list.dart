import 'package:flutter/material.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';
import 'package:gymapp/pages/gyms_page/widgets/add_gym.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/gym_view.dart';

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
            onCreateGym: () {},
          )
        ],
      ),
      // ignore: prefer_const_constructors
      body: Column(
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: GymView(
              imageUrl:
                  'https://scontent.feze16-1.fna.fbcdn.net/v/t39.30808-6/305403021_513378204126437_6895561525484102704_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_ohc=-Funlk14yo8AX8gL8B4&_nc_ht=scontent.feze16-1.fna&oh=00_AfBnNeAFHfbnUJ0BMd8stZS42mO0P7WYT0zw-aAtn474NA&oe=656681FE',
              name: 'Green Fitness Sucursal Monte Grande',
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymapp/main.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: fuckinKey,
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          fuckinKey.currentContext!.go('/gyms');
        },
        child: const Text('Move'),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';

class MyChats extends StatefulWidget {
  final GymData gymData;
  const MyChats({super.key, required this.gymData});

  @override
  State<MyChats> createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Chats in ${widget.gymData.name}'),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}

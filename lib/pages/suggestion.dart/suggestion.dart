import 'package:flutter/material.dart';
import 'package:gymapp/navigation/widgets/navigationdrawer.dart';

class Suggestion extends StatefulWidget {
  const Suggestion({super.key});

  @override
  State<Suggestion> createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('Send a suggestion'),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}

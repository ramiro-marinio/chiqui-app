import 'package:flutter/material.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/demodata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/exercise.dart';

class ExerciseDemonstrations extends StatefulWidget {
  final String gymId;
  const ExerciseDemonstrations({super.key, required this.gymId});

  @override
  State<ExerciseDemonstrations> createState() => _ExerciseDemonstrationsState();
}

class _ExerciseDemonstrationsState extends State<ExerciseDemonstrations> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                "Exercises",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        ExerciseDemo(
            demoData:
                DemonstrationData(exerciseName: 'Bicep Curls', repUnit: true)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gymapp/firebase/widgets/icontext.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/demodata.dart';

class ExerciseDemo extends StatelessWidget {
  final DemonstrationData demoData;
  const ExerciseDemo({super.key, required this.demoData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(demoData.exerciseName),
          onTap: () {},
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              demoData.repUnit
                  ? const Icon(Icons.fitness_center)
                  : const Icon(Icons.timer),
              Text(demoData.repUnit ? 'Repped Exercise' : 'Timed Exercise')
            ],
          ),
        ),
        const AdaptiveDivider(
          thickness: 0.2,
          indent: 8,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/interfaces/tag.dart';

class WorkAreasField extends StatefulWidget {
  final List<String> workAreas;
  final Function(String workArea) addWorkArea;
  final Function(int position) removeWorkArea;
  const WorkAreasField(
      {super.key,
      required this.workAreas,
      required this.addWorkArea,
      required this.removeWorkArea});

  @override
  State<WorkAreasField> createState() => _WorkAreasFieldState();
}

class _WorkAreasFieldState extends State<WorkAreasField> {
  final TextEditingController muscleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.list),
              Text(
                "Muscles Trained in exercise",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 80,
          child: MasonryGridView(
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              widget.workAreas.length,
              (index) => Tag(
                text: widget.workAreas[index],
                remove: () {
                  setState(() {
                    widget.removeWorkArea(index);
                  });
                },
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: muscleController,
                decoration: const InputDecoration(
                    hintText: 'What does this exercise work?'),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    print(muscleController.text);
                    widget.addWorkArea(muscleController.text);
                  });
                  muscleController.clear();
                },
                icon: const Icon(Icons.add_circle),
                color: adaptiveColor(const Color.fromARGB(255, 0, 0, 100),
                    const Color.fromARGB(255, 107, 107, 159), context),
              ),
            )
          ],
        )
      ],
    );
  }
}

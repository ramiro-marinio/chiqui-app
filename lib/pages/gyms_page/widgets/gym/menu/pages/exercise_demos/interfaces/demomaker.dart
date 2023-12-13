import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/firebase/widgets/profile_config/fields/genderfield.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/functions/random_string.dart';
import 'package:gymapp/navigation/widgets/confirmationdialog.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/fields/controllerfield.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/demodata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/interfaces/extraadvice.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/interfaces/workareasfield.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/interfaces/videopickfield.dart';
import 'package:provider/provider.dart';

class DemoMaker extends StatefulWidget {
  final String gymId;
  final DemonstrationData? editData;
  const DemoMaker({super.key, required this.gymId, this.editData});

  @override
  State<DemoMaker> createState() => _DemoMakerState();
}

class _DemoMakerState extends State<DemoMaker> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> workAreas = [];
  final TextEditingController adviceController = TextEditingController();
  String? videoPath;
  bool unit = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    DemonstrationData? editData = widget.editData;
    if (editData != null) {
      nameController.text = editData.exerciseName;
      descriptionController.text = editData.description ?? '';
      workAreas = editData.workAreas;
      adviceController.text = editData.advice ?? '';
      videoPath = editData.resourceURL;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build a Demonstration'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ControllerField(
                controller: nameController,
                title: 'Exercise Name',
                icon: const Icon(Icons.fitness_center),
                maxLength: 100,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please insert a title';
                  } else {
                    return null;
                  }
                },
              ),
              const AdaptiveDivider(),
              SwitchField(
                icon: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.fitness_center), Icon(Icons.timer)]),
                title: 'Exercise Unit',
                valA: 'Time',
                valB: 'Reps',
                thumbColors: const [
                  Colors.green,
                  Colors.blue,
                ],
                trackColors: [
                  const Color.fromARGB(255, 0, 100, 0),
                  adaptiveColor(const Color.fromARGB(255, 0, 0, 100),
                      const Color.fromARGB(255, 0, 0, 200), context),
                ],
                value: unit,
                onChange: (value) {
                  unit = value;
                },
              ),
              const AdaptiveDivider(),
              ControllerField(
                controller: descriptionController,
                title: 'Exercise Description',
                icon: const Icon(Icons.info),
                maxLength: 1000,
                maxLines: 6,
              ),
              const AdaptiveDivider(),
              WorkAreasField(
                workAreas: workAreas,
                addWorkArea: (workArea) {
                  workAreas.add(workArea);
                },
                removeWorkArea: (position) {
                  workAreas.removeAt(position);
                },
              ),
              const AdaptiveDivider(),
              ExerciseAdviceField(
                controller: adviceController,
              ),
              const AdaptiveDivider(),
              VideoPickField(
                chooseVideo: (path) {
                  videoPath = path;
                },
                initialVideo: videoPath,
              ),
              const SizedBox(
                height: 50,
                width: 50,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          showDialog(
            context: context,
            builder: (context) => ConfirmationDialog(
              title: editData == null ? 'Create Exercise?' : 'Modify Exercise?',
              description: 'Make sure you inserted the correct data!',
              yes: () {
                DemonstrationData demonstrationData = DemonstrationData(
                  exerciseName: nameController.text,
                  repUnit: unit,
                  advice: adviceController.text,
                  workAreas: workAreas,
                  description: descriptionController.text,
                  gymId: widget.gymId,
                  id: editData?.id ?? generateRandomString(28),
                );
                if (context.mounted) {
                  if (editData == null) {
                    context.read<ApplicationState>().addDemonstration(
                          demonstrationData,
                          videoPath != null ? File(videoPath!) : null,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Demonstration Saved Successfully!'),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    context
                        .read<ApplicationState>()
                        .editDemonstration(demonstrationData, videoPath);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Demonstration Saved Successfully!'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                }
              },
            ),
          );
        },
        child:
            editData != null ? const Icon(Icons.save) : const Icon(Icons.check),
      ),
    );
  }
}

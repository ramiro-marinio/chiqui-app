import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/firebase/widgets/profile_config/fields/genderfield.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/functions/showprogressdialog.dart';
import 'package:gymapp/navigation/widgets/confirmationdialog.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/fields/controllerfield.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/demodata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/interfaces/extraadvice.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/interfaces/workareasfield.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/pages/exercise_demos/interfaces/videopickfield.dart';
import 'package:provider/provider.dart';

class DemoMaker extends StatefulWidget {
  final String gymId;
  const DemoMaker({super.key, required this.gymId});

  @override
  State<DemoMaker> createState() => _DemoMakerState();
}

class _DemoMakerState extends State<DemoMaker> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> workAreas = [];
  String advice = "";
  String? videoPath;
  bool unit = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
              ExtraAdviceField(
                onChange: (text) {
                  advice = text;
                },
              ),
              const AdaptiveDivider(),
              VideoPickField(
                chooseVideo: (path) {
                  videoPath = path;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        title: 'Create Exercise?',
                        description: 'Make sure you inserted the correct data!',
                        yes: () async {
                          showProgressDialog(
                              'Saving Demonstration...', context);
                          await context
                              .read<ApplicationState>()
                              .addDemonstration(
                                DemonstrationData(
                                  exerciseName: nameController.text,
                                  repUnit: unit,
                                  advice: advice,
                                  workAreas: workAreas,
                                  description: descriptionController.text,
                                  gymId: widget.gymId,
                                ),
                                videoPath != null ? File(videoPath!) : null,
                              );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Demonstration Created Successfully!'),
                              ),
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    );
                  },
                  child: const Text('Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

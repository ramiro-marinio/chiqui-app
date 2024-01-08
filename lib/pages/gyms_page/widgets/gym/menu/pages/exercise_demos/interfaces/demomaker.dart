import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/firebase/widgets/profile_config/fields/genderfield.dart';
import 'package:gymapp/functions/adaptive_color.dart';
import 'package:gymapp/functions/random_string.dart';
import 'package:gymapp/functions/showwarningdialog.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/fields/controllerfield.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/demodata.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/interfaces/extraadvice.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/interfaces/workareasfield.dart';
import 'package:gymapp/pages/gyms_page/widgets/gym/menu/pages/exercise_demos/interfaces/videopickfield.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool? unit;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    unit ??= widget.editData?.repUnit ?? true;
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    DemonstrationData? editData = widget.editData;
    if (editData != null) {
      nameController.text = editData.exerciseName;
      descriptionController.text = editData.description ?? '';
      workAreas = editData.workAreas;
      adviceController.text = editData.advice ?? '';
      videoPath = editData.resourceURL;
    }
    return WillPopScope(
      onWillPop: () async {
        bool exit = false;
        await showWarningDialog(
          title: appLocalizations.leavePrompt,
          description: appLocalizations.willNotBeSaved,
          context: context,
          yes: () {
            exit = true;
          },
        );
        return exit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appLocalizations.buildDemo),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ControllerField(
                  controller: nameController,
                  title: appLocalizations.exerciseName,
                  icon: const Icon(Icons.fitness_center),
                  maxLength: 100,
                  showMaxlength: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return appLocalizations.missingValue;
                    } else {
                      return null;
                    }
                  },
                ),
                const AdaptiveDivider(),
                SwitchField(
                  icon: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fitness_center),
                        Icon(Icons.timer)
                      ]),
                  title: appLocalizations.exerciseUnit,
                  valA: appLocalizations.time,
                  valB: appLocalizations.reps,
                  thumbColors: const [
                    Colors.green,
                    Colors.blue,
                  ],
                  trackColors: [
                    const Color.fromARGB(255, 0, 100, 0),
                    adaptiveColor(const Color.fromARGB(255, 0, 0, 100),
                        const Color.fromARGB(255, 0, 0, 200), context),
                  ],
                  value: unit!,
                  onChange: (value) {
                    unit = value;
                  },
                ),
                const AdaptiveDivider(),
                ControllerField(
                  controller: descriptionController,
                  title: appLocalizations.exerciseDescription,
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
            showWarningDialog(
              title: editData == null
                  ? appLocalizations.createDemoPrompt
                  : appLocalizations.saveDemoPrompt,
              description: appLocalizations.demoPromptDetails,
              context: context,
              yes: () {
                DemonstrationData demonstrationData = DemonstrationData(
                  exerciseName: nameController.text,
                  repUnit: unit!,
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
                      SnackBar(
                        content: Text(appLocalizations.successful),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    context
                        .read<ApplicationState>()
                        .editDemonstration(demonstrationData, videoPath);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(appLocalizations.successful),
                      ),
                    );
                    Navigator.pop(context);
                  }
                }
              },
            );
          },
          child: editData != null
              ? const Icon(Icons.save)
              : const Icon(Icons.check),
        ),
      ),
    );
  }
}

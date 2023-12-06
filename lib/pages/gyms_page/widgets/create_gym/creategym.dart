import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymapp/firebase/app_state.dart';
import 'package:gymapp/firebase/gyms/gymdata.dart';
import 'package:gymapp/firebase/widgets/profile_config/adaptivedivider.dart';
import 'package:gymapp/functions/random_string.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/fields/controllerfield.dart';
import 'package:gymapp/pages/gyms_page/widgets/create_gym/fields/gympicpicker.dart';
import 'package:provider/provider.dart';

class CreateGym extends StatefulWidget {
  const CreateGym({super.key});

  @override
  State<CreateGym> createState() => _CreateGymState();
}

class _CreateGymState extends State<CreateGym> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? photoPath;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final ApplicationState applicationState =
        Provider.of<ApplicationState>(context);
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Exit?"),
            content: const Text(
                "The gym you are creating will not be saved. Proceed anyway?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        );
        return true;
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Create a Gym"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const AutoSizeText(
                  "Create your Gym",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const AdaptiveDivider(),
                ControllerField(
                  icon: const Icon(Icons.edit),
                  title: "Gym Name",
                  controller: nameController,
                  maxLength: 100,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please insert a name';
                    } else {
                      return null;
                    }
                  },
                ),
                const AdaptiveDivider(),
                ControllerField(
                  controller: descriptionController,
                  title: "Gym Description",
                  maxLines: 6,
                  maxLength: 1500,
                  icon: const Icon(Icons.info),
                ),
                const AdaptiveDivider(),
                GymPicPicker(
                  photoPath: photoPath,
                  deletePhoto: () {
                    setState(() {
                      photoPath = null;
                    });
                  },
                  pickPhoto: (xFile) {
                    setState(() {
                      photoPath = xFile.path;
                    });
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text("Creating Gym..."),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator.adaptive(),
                    ],
                  ),
                ),
              );
              try {
                String id = generateRandomString(28);
                GymData startingData = GymData(
                  ownerId: applicationState.user!.uid,
                  name: nameController.text,
                  description: descriptionController.text,
                );
                if (photoPath != null) {
                  String picPath =
                      await applicationState.createGymPic(id, File(photoPath!));
                  startingData.photoURL = picPath;
                }
                DocumentReference gymReference =
                    await applicationState.createGym(startingData, id);
                await applicationState.addInviteData(id);
                await applicationState.joinGym(gymReference);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Error")));
                }
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Gym created successfully!")));
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: const Icon(Icons.check),
          ),
        ),
      ),
    );
  }
}
